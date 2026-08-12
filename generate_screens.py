import os

base_dir = r"c:\Users\muhmm\OneDrive\Desktop\نيلكو\saytara\lib\features"

screens = {
    "rep/home": "RepHomeScreen",
    "rep/route": "RepRouteScreen",
    "rep/visits/new_visit": "NewVisitScreen",
    "rep/visits/visit_history": "VisitHistoryScreen",
    "rep/orders/rep_orders": "RepOrdersScreen",
    "rep/orders/new_order": "NewOrderScreen",
    "rep/stock/client_stock": "ClientStockScreen",
    "rep/performance/rep_performance": "RepPerformanceScreen",
    
    "manager/home": "ManagerHomeScreen",
    "manager/reps": "RepsListScreen",
    "manager/routes": "RoutesManagerScreen",
    "manager/orders": "OrdersManagerScreen",
    "manager/reports": "ReportsScreen",
    
    "warehouse/home": "WarehouseHomeScreen",
    "warehouse/stock": "StockManagementScreen",
    "warehouse/orders": "IncomingOrdersScreen",
}

template = """import 'package:flutter/material.dart';

class {class_name} extends StatelessWidget {{
  const {class_name}({{Key? key}}) : super(key: key);

  @override
  Widget build(BuildContext context) {{
    return Scaffold(
      appBar: AppBar(title: const Text('{class_name}')),
      body: const Center(
        child: Text('{class_name} - Placeholder', style: TextStyle(fontSize: 24)),
      ),
    );
  }}
}}
"""

for path, class_name in screens.items():
    # Split path to get dir and file name
    parts = path.split('/')
    file_name = parts[-1] + "_screen.dart"
    
    # If the last part is just the feature name (like home), keep it simple, otherwise use full path
    if len(parts) > 2:
        dir_path = os.path.join(base_dir, parts[0], parts[1])
    else:
        dir_path = os.path.join(base_dir, parts[0], parts[1])
        
    os.makedirs(dir_path, exist_ok=True)
    
    full_path = os.path.join(dir_path, file_name)
    with open(full_path, "w", encoding="utf-8") as f:
        f.write(template.format(class_name=class_name))

print("All screens generated.")
