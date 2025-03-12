part of 'chat_bloc_bloc.dart';

@immutable
sealed class ChatBlocState {}

class ChatBlocInitial extends ChatBlocState {}

class ChatBlocBlocLoading extends ChatBlocState {}

class ChatBlocBlocLoaded extends ChatBlocState {}

class ChatBlocBlocError extends ChatBlocState {}
