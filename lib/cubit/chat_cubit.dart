import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../models/message_model.dart';
import '../widgets/constant_widget.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  List<Message> messagesList = [];
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollection);
  void addMessage({required String message, required String email}) {
    messages
        .add({'messages': message, 'created at': DateTime.now(), 'id': email});
  }

  void getMEssage() {
    messages
        .orderBy('created at', descending: true)
        .snapshots()
        .listen((event) {
      for (int i = 0; i < event.docs.length; i++) {
        messagesList.add(Message.fromJson(event.docs[i]));
      } //عملت ليست فاضية وبضيف فيها اي تغيير ف ال docs
      emit(ChatSuccess(messagesList: messagesList));
    }); // هنا مش بس بجيب الداتا انا بقوله تسمع اي تغيير يحصل عندك ف الداتا عشان اللي يتضاف جديد يظهر ف ال ui
  }
}
