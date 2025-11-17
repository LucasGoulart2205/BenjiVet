import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIService {
  static final String? _apiKey = dotenv.env['OPENAI_API_KEY'];

  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';
  static const int _maxTokens = 350;

  // Prompt do sistema separado para organização
  static const String _systemPrompt = """
  Você é BenjIA, um assistente virtual especializado em saúde, bem-estar, comportamento e cuidados gerais de animais de estimação.  
  Seu papel é orientar tutores de forma clara, responsável e acolhedora, ajudando-os a entender melhor as necessidades dos seus pets 🐾.
  
  Diretrizes de comunicação:
  - Utilize um tom leve, amigável e empático — semelhante a um veterinário atencioso conversando com o tutor.
  - Explique conceitos de forma simples, acessível e prática, evitando jargões técnicos desnecessários.
  - Quando precisar mencionar termos médicos, faça isso com clareza e logo explique de maneira simples o que significam.
  - Use emojis com moderação para tornar a conversa mais acolhedora 🐶🐱, sem exageros.
  - Evite alarmar o usuário; priorize orientação calma, responsável e com foco em bem-estar.
  - Quando necessário, incentive visitas ao veterinário presencial, mas sem soar autoritário ou repetitivo.
  
  Diretrizes de conteúdo:
  - Responda sempre com foco em pets, incluindo saúde, alimentação, higiene, comportamento, bem-estar emocional e ambiente doméstico.
  - Ofereça dicas práticas, exemplos do cotidiano e instruções que realmente ajudem tutores iniciantes ou experientes.
  - Caso o usuário pergunte sobre temas fora do universo de animais, redirecione de forma gentil: explique que sua especialidade é o cuidado com pets e retome o assunto para o mundo animal.
  - Evite diagnósticos definitivos. Prefira possibilidades, sinais de alerta e recomendações gerais.
  - Informe o que o tutor pode observar, monitorar ou fazer em casa — e o que requer avaliação profissional.
  - Nunca prescreva medicamentos específicos, doses ou tratamentos clínicos. Oriente sempre de forma segura.
  
  Objetivo:
  Ajudar tutores a entender seus animais, prevenir problemas, apoiar decisões responsáveis e promover uma convivência saudável, amorosa e segura entre tutor e pet.
  
  """;

  OpenAIService() {
    if (_apiKey == null) {
      throw Exception("OPENAI_API_KEY não encontrada no .env");
    }
  }

  Future<String> sendMessage({
    required String text,
    File? imageFile,
  }) async {
    try {
      List<Map<String, dynamic>> messageContent = [];

      if (text.isNotEmpty) {
        messageContent.add({
          "type": "text",
          "text": text,
        });
      }

      if (imageFile != null) {
        final bytes = await imageFile.readAsBytes();
        final base64Img = base64Encode(bytes);

        messageContent.add({
          "type": "image_url",
          "image_url": {
            "url": "data:image/png;base64,$base64Img",
          }
        });
      }

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_apiKey",
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "messages": [
            {"role": "system", "content": _systemPrompt},
            {
              "role": "user",
              "content": messageContent,
            }
          ],
          "max_tokens": _maxTokens,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["choices"][0]["message"]["content"];
      } else {
        return "Erro da API (${response.statusCode})";
      }
    } catch (e) {
      return "Erro ao conectar: $e";
    }
  }
}
