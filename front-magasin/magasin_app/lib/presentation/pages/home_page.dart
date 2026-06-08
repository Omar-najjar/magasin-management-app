import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/product/product_bloc.dart';
import '../blocs/product/product_event.dart';
import '../blocs/product/product_state.dart';
import '../../data/services/api_service.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => ProductBloc()..add(LoadProducts()),

      child: Scaffold(

        // 🔍 SEARCH + LOGOUT
        appBar: AppBar(
          title: Builder(
            builder: (context) {
              return TextField(
                decoration: InputDecoration(
                  hintText: "Rechercher...",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  context.read<ProductBloc>().add(
                    SearchProductEvent(value),
                  );
                },
              );
            },
          ),

          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('token');

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              },
            )
          ],
        ),

        // 📦 BODY
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {

            if (state is ProductLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is ProductLoaded) {

              if (state.products.isEmpty) {
                return Center(child: Text("Aucun produit"));
              }

              return ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {

                  final p = state.products[index];

                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: ListTile(
                      title: Text(
                        p['name'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("💰 Vente: ${p['sale_price']}"),
                          Text("📦 Achat: ${p['purchase_price']}"),
                          Text("📈 Profit: ${p['profit']}"),
                          Text("📂 ${p['category_name'] ?? 'Sans catégorie'}"),
                        ],
                      ),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          // ✏️ EDIT
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _showEditDialog(context, p);
                            },
                          ),

                          // 🗑️ DELETE
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context.read<ProductBloc>().add(
                                DeleteProductEvent(p['id']),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            if (state is ProductError) {
              return Center(child: Text(state.message));
            }

            return Center(child: Text("Chargement..."));
          },
        ),

        // ➕ ADD
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddDialog(context),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  // ➕ ADD PRODUCT
  void _showAddDialog(BuildContext context) {

    final nameController = TextEditingController();
    final purchaseController = TextEditingController();
    final saleController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {

        return FutureBuilder(
          future: ApiService.getCategories(),

          builder: (context, snapshot) {

            if (!snapshot.hasData) {
              return AlertDialog(
                content: SizedBox(
                  height: 80,
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            }

            final categories = snapshot.data!;
            int? selectedCategory;

            return StatefulBuilder(
              builder: (context, setState) {

                return AlertDialog(
                  title: Text("Ajouter produit"),

                  content: SingleChildScrollView(
                    child: Column(
                      children: [

                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: "Nom"),
                        ),

                        TextField(
                          controller: purchaseController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: "Prix achat"),
                        ),

                        TextField(
                          controller: saleController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: "Prix vente"),
                        ),

                        SizedBox(height: 10),

                        DropdownButtonFormField<int>(
                          hint: Text("Choisir catégorie"),
                          value: selectedCategory,
                          items: categories.map<DropdownMenuItem<int>>((c) {
                            return DropdownMenuItem<int>(
                              value: c['id'],
                              child: Text(c['name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  actions: [
                    ElevatedButton(
                      onPressed: () {

                        // 🔒 Validation
                        if (nameController.text.isEmpty ||
                            purchaseController.text.isEmpty ||
                            saleController.text.isEmpty ||
                            selectedCategory == null) {

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Remplir tous les champs")),
                          );
                          return;
                        }

                        final purchase =
                            double.tryParse(purchaseController.text) ?? 0;

                        final sale =
                            double.tryParse(saleController.text) ?? 0;

                        context.read<ProductBloc>().add(
                          AddProductEvent({
                            "name": nameController.text,
                            "purchase_price": purchase,
                            "sale_price": sale,
                            "category_id": selectedCategory
                          }),
                        );

                        Navigator.pop(context);
                      },
                      child: Text("Ajouter"),
                    )
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  // ✏️ EDIT PRODUCT
  void _showEditDialog(BuildContext context, dynamic p) {

    final nameController = TextEditingController(text: p['name']);
    final purchaseController =
        TextEditingController(text: p['purchase_price'].toString());
    final saleController =
        TextEditingController(text: p['sale_price'].toString());

    showDialog(
      context: context,
      builder: (_) {

        return AlertDialog(
          title: Text("Modifier produit"),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              TextField(controller: nameController),

              TextField(
                controller: purchaseController,
                keyboardType: TextInputType.number,
              ),

              TextField(
                controller: saleController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),

          actions: [
            ElevatedButton(
              onPressed: () {

                final purchase =
                    double.tryParse(purchaseController.text) ?? 0;

                final sale =
                    double.tryParse(saleController.text) ?? 0;

                context.read<ProductBloc>().add(
                  UpdateProductEvent(
                    p['id'],
                    {
                      "name": nameController.text,
                      "purchase_price": purchase,
                      "sale_price": sale,
                      "category_id": p['category_id']
                    },
                  ),
                );

                Navigator.pop(context);
              },
              child: Text("Modifier"),
            )
          ],
        );
      },
    );
  }
}