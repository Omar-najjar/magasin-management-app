import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_event.dart';
import 'product_state.dart';
import '../../../data/services/api_service.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {

  ProductBloc() : super(ProductInitial()) {

    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());

      try {
        final products = await ApiService.getProducts();
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<AddProductEvent>((event, emit) async {
      try {
        print('[ProductBloc] Adding product: ${event.product}');
        final response = await ApiService.addProduct(event.product);
        print('[ProductBloc] Add response: $response');
        
        // Reload produits après ajout
        final products = await ApiService.getProducts();
        emit(ProductLoaded(products));
        emit(ProductSuccess('Produit ajouté avec succès'));

      } catch (e) {
        print('[ProductBloc] Add error: $e');
        emit(ProductError(e.toString()));
      }
    });

    on<UpdateProductEvent>((event, emit) async {
      try {
        await ApiService.updateProduct(event.id, event.product);
        final products = await ApiService.getProducts();
        emit(ProductLoaded(products));
        emit(ProductSuccess('Produit modifié avec succès'));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<DeleteProductEvent>((event, emit) async {
      try {
        await ApiService.deleteProduct(event.id);
        final products = await ApiService.getProducts();
        emit(ProductLoaded(products));
        emit(ProductSuccess('Produit supprimé avec succès'));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<SearchProductEvent>((event, emit) async {
      if (event.query.isEmpty) {
        // Si recherche vide, recharger tous les produits
        add(LoadProducts());
        return;
      }

      emit(ProductLoading());

      try {
        final products = await ApiService.searchProducts(event.query);
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}