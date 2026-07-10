import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flowpay/app/theme/app_colors.dart';
import 'package:flowpay/app/theme/app_spacing.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction, size: 64, color: AppColors.primary),
              SizedBox(height: AppSpacing.md),
              Text(
                'Fluxo de Cadastro em Construção',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Aqui teremos um formulário passo-a-passo (Stepper) para coletar os dados do lojista (CNPJ, Razão Social, etc).',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
