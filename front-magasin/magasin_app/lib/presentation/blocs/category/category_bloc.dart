import 'package:flutter_bloc/flutter_bloc.dart';

import 'category_event.dart';
import 'category_state.dart';
import '../../../data/services/api_service.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {

  CategoryBloc() : super(CategoryInitial()) {

    on<LoadCategories>((event, emit) async {
      emit(CategoryLoading());

      try {
        final categories = await ApiService.getCategories();
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    on<AddCategoryEvent>((event, emit) async {
      try {
        print('[CategoryBloc] Adding category: ${event.name}');
        await ApiService.addCategory(event.name);
        print('[CategoryBloc] Category added successfully');
        
        final categories = await ApiService.getCategories();
        emit(CategoryLoaded(categories));
        emit(CategorySuccess('Catégorie ajoutée avec succès'));
      } catch (e) {
        print('[CategoryBloc] Add error: $e');
        emit(CategoryError(e.toString()));
      }
    });

    on<DeleteCategoryEvent>((event, emit) async {
      try {
        await ApiService.deleteCategory(event.id);
        final categories = await ApiService.getCategories();
        emit(CategoryLoaded(categories));
        emit(CategorySuccess('Catégorie supprimée avec succès'));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });
  }
}
