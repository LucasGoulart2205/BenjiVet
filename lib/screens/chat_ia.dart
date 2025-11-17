import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/openai_service.dart';

class ChatIaScreen extends StatefulWidget {
  const ChatIaScreen({super.key});

  @override
  State<ChatIaScreen> createState() => _ChatIaScreenState();
}

class _ChatIaScreenState extends State<ChatIaScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  final OpenAIService _openAIService = OpenAIService();
  bool _isLoading = false;

  File? _selectedImage;

  // Animação
  late final AnimationController _dotController;
  late final Animation<double> _dotAnim1;
  late final Animation<double> _dotAnim2;
  late final Animation<double> _dotAnim3;

  @override
  void initState() {
    super.initState();

    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _dotAnim1 = CurvedAnimation(
      parent: _dotController,
      curve: const Interval(0.0, 0.66, curve: Curves.easeInOut),
    );
    _dotAnim2 = CurvedAnimation(
      parent: _dotController,
      curve: const Interval(0.16, 0.82, curve: Curves.easeInOut),
    );
    _dotAnim3 = CurvedAnimation(
      parent: _dotController,
      curve: const Interval(0.32, 1.0, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  // =============================================================
  //                 ENVIAR MENSAGEM (TEXTO + IMAGEM)
  // =============================================================
  void _sendMessage() async {
    final text = _controller.text.trim();

    if (text.isEmpty && _selectedImage == null) return;

    setState(() {
      _messages.add({
        "user": {
          "text": text,
          "image": _selectedImage?.path,
        }
      });
      _isLoading = true;
    });

    _controller.clear();
    _scrollToBottom();

    final response = await _openAIService.sendMessage(
      text: text,
      imageFile: _selectedImage,
    );

    setState(() {
      _messages.add({"ia": response});
      _isLoading = false;
      _selectedImage = null;
    });

    _scrollToBottom();
  }

  // =============================================================
  //                         PICK IMAGE
  // =============================================================
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  // =============================================================
  //                         SCROLL
  // =============================================================
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // =============================================================
  //                       WIDGET MENSAGEM
  // =============================================================
  Widget _buildMessageBubble(Map<String, dynamic> msg, bool isUser) {
    final text = msg["text"];
    final imgPath = msg["image"];

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
        isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (imgPath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(imgPath),
                width: 180,
              ),
            ),
          if (text != null && text.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              constraints: const BoxConstraints(maxWidth: 280),
              decoration: BoxDecoration(
                color: isUser ? Colors.teal : Colors.grey.shade300,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft:
                  isUser ? const Radius.circular(16) : const Radius.circular(0),
                  bottomRight:
                  isUser ? const Radius.circular(0) : const Radius.circular(16),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  color: isUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ANIMAÇÃO - "IA DIGITANDO"
  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("BenjIA está digitando...",
                style: TextStyle(fontStyle: FontStyle.italic)),
            const SizedBox(width: 10),
            Row(
              children: [
                _animatedDot(_dotAnim1),
                _animatedDot(_dotAnim2),
                _animatedDot(_dotAnim3),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _animatedDot(Animation<double> anim) {
    return AnimatedBuilder(
      animation: anim,
      builder: (context, _) {
        return Opacity(
          opacity: 0.3 + anim.value * 0.7,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 6,
            height: 6,
            decoration:
            const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
          ),
        );
      },
    );
  }

  // =============================================================
  //                           UI
  // =============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BenjIA (Assistente Pet)"),
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(14),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isLoading && index == _messages.length) {
                    return _buildTypingIndicator();
                  }

                  final msg = _messages[index];
                  final isUser = msg.containsKey("user");
                  final data = msg.values.first;

                  return _buildMessageBubble(data, isUser);
                },
              ),
            ),

            if (_selectedImage != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _selectedImage!,
                    width: 140,
                  ),
                ),
              ),

            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image, size: 28),
                    onPressed: _pickImage,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration:
                      const InputDecoration(hintText: "Digite sua mensagem..."),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.teal),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
