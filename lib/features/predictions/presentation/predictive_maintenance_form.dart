import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';

class PredictiveMaintenanceForm extends ConsumerStatefulWidget {
  const PredictiveMaintenanceForm({super.key});

  @override
  ConsumerState<PredictiveMaintenanceForm> createState() => _PredictiveMaintenanceFormState();
}

class _PredictiveMaintenanceFormState extends ConsumerState<PredictiveMaintenanceForm> {
  final _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio();
  bool _isLoading = false;

  // Controllers for the 7 core numeric KPIs
  final TextEditingController _availabilityController = TextEditingController();
  final TextEditingController _erabController = TextEditingController();
  final TextEditingController _cssrController = TextEditingController();
  final TextEditingController _dcrController = TextEditingController();
  final TextEditingController _latencyController = TextEditingController();
  final TextEditingController _throughputController = TextEditingController();
  final TextEditingController _prbController = TextEditingController();

  // Region list matching your 15 regions
  final List<String> _regions = [
    "AHAFO",
    "ASHANTI",
    "BONO",
    "BONO EAST",
    "CENTRAL",
    "EASTERN",
    "GREATER ACCRA",
    "NORTH EAST",
    "NORTHERN",
    "OTI",
    "SAVANNAH",
    "UPPER EAST",
    "UPPER WEST",
    "VOLTA",
    "WESTERN",
    "WESTERN NORTH"
  ];
  
  String? _selectedRegion = "GREATER ACCRA";

  @override
  void dispose() {
    _availabilityController.dispose();
    _erabController.dispose();
    _cssrController.dispose();
    _dcrController.dispose();
    _latencyController.dispose();
    _throughputController.dispose();
    _prbController.dispose();
    super.dispose();
  }

  // Method to build text form fields cleanly
  Widget _buildNumberField(String label, TextEditingController controller, String helperText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          helperMaxLines: 2,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
      ),
    );
  }

  // Function to build the final payload map and send to API
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        // 1. Build the simple payload (the Python backend handles preprocessing)
        final Map<String, dynamic> payload = {
          "AVAILABILITY": double.parse(_availabilityController.text),
          "ERAB_Establishment_SUCCESS_RATE": double.parse(_erabController.text),
          "CALL_SET_UP_SUCCESS_RATE": double.parse(_cssrController.text),
          "DROP_CALL_RATE": double.parse(_dcrController.text),
          "AVERAGE_LATENCY": double.parse(_latencyController.text),
          "CELL_TROUGHPUT": double.parse(_throughputController.text),
          "PRB_UTILIZATION": double.parse(_prbController.text),
          "REGION": _selectedRegion,
        };

        final response = await _dio.post(
          '${AppConstants.mlApiBaseUrl}/predict',
          data: payload,
        );

        if (response.statusCode == 200) {
          final predictionResult = response.data;
          
          // Save to Supabase
          await Supabase.instance.client.from('predictions').insert({
            'fault_type': predictionResult['predicted_fault'],
            'probability': predictionResult['confidence'],
            'risk_level': predictionResult['confidence'] > 0.8 ? 'High' : (predictionResult['confidence'] > 0.5 ? 'Medium' : 'Low'),
            'recommended_action': 'ML generated prediction from KPI input.',
          });

          if (!mounted) return;
          _showResultDialog(predictionResult);
        } else {
          throw Exception("Failed to get prediction");
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showResultDialog(Map<String, dynamic> data) {
    final probs = data['all_probabilities'] as Map<String, dynamic>;
    final sortedProbs = probs.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.analytics_outlined, color: Colors.purple),
            SizedBox(width: 10),
            Text("AI Analysis Results"),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Primary Prediction", style: TextStyle(fontSize: 12)),
                          Text(data['predicted_fault'], 
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                    ),
                    Text("${(data['confidence'] * 100).toStringAsFixed(1)}%",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.purple)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text("Probability Breakdown:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 10),
              ...sortedProbs.take(4).map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key, style: const TextStyle(fontSize: 13)),
                        Text("${(entry.value * 100).toStringAsFixed(2)}%"),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: entry.value,
                      backgroundColor: Colors.grey.withValues(alpha: 0.1),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Done"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Telecom Maintenance Predictor')),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const Text(
                    "Enter Cell Site KPIs",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  
                  _buildNumberField(
                    "Availability (%)", 
                    _availabilityController, 
                    "Percentage of time the cell site was operational (typically 0-100%)."
                  ),
                  _buildNumberField(
                    "E-RAB Establishment Success Rate (%)", 
                    _erabController, 
                    "Success rate of radio bearer setup. Values closer to 100% are better."
                  ),
                  _buildNumberField(
                    "Call Set Up Success Rate (CSSR %)", 
                    _cssrController, 
                    "Percentage of calls successfully initiated. High values indicate better performance."
                  ),
                  _buildNumberField(
                    "Drop Call Rate (DCR %)", 
                    _dcrController, 
                    "Percentage of established calls that ended prematurely. Lower is better (typically <2%)."
                  ),
                  _buildNumberField(
                    "Average Latency (ms)", 
                    _latencyController, 
                    "Network response time in milliseconds. Lower latency means better user experience."
                  ),
                  _buildNumberField(
                    "Cell Throughput", 
                    _throughputController, 
                    "The amount of data successfully transferred through the cell (e.g., in Mbps)."
                  ),
                  _buildNumberField(
                    "PRB Utilization (%)", 
                    _prbController, 
                    "Physical Resource Block usage. High usage indicates heavy cell congestion."
                  ),
                  
                  const SizedBox(height: 20),
                  const Text(
                    "Select Region",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    value: _selectedRegion,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      helperText: "The geographic region where the base station is located.",
                    ),
                    items: _regions.map((String region) {
                      return DropdownMenuItem<String>(
                        value: region,
                        child: Text(region),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRegion = newValue;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      "Run Health Prediction",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
