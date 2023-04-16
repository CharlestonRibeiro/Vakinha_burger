import 'package:flutter/material.dart';
import 'package:vakinha_burger_provider_com_bloc/app/core/ui/styles/text_styles.dart';
import 'package:vakinha_burger_provider_com_bloc/app/core/ui/widgets/delivery_appbar.dart';
import 'package:vakinha_burger_provider_com_bloc/app/core/ui/widgets/delivery_button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  static const route = 'RegisterPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DeliveryAppbar(),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(
                      'Cadastro',
                      style: context.textStyles.textTitle,
                    ),
                    Text(
                      'Preencha os campos abaixo para criar o seu cadastro.',
                      style: context.textStyles.textMedium.copyWith(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                    decoration: const InputDecoration(labelText: 'Nome'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'E-mail'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Senha'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Confirma Senha'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                   Center(
                    child: DeliveryButton(
                      customLabel: 'CADASTRAR',
                      customOnPressed: () {},
                      customWidth: double.infinity,
                    ),
                  )
                  ])))),
    );
  }
}
