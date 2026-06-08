import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {}

class AddProductEvent extends ProductEvent {
  final Map<String, dynamic> product;

  AddProductEvent(this.product);
}

class UpdateProductEvent extends ProductEvent {
  final int id;
  final Map<String, dynamic> product;

  UpdateProductEvent(this.id, this.product);
}

class DeleteProductEvent extends ProductEvent {
  final int id;

  DeleteProductEvent(this.id);
}

class SearchProductEvent extends ProductEvent {
  final String query;

  SearchProductEvent(this.query);
}