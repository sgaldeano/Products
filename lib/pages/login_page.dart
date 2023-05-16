import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../decorations/decorations.dart' show InputDecorations;
import '../providers/providers.dart';
import '../services/services.dart' show AuthService, NotificationsService;
import '../themes/app_themes.dart';
import '../validators/validators.dart' show LoginFormValidator;
import '../widgets/widgets.dart' show AuthBackground, FormContainer;
import 'pages.dart' show HomePage, RegisterPage;

class LoginPage extends StatelessWidget {

  static const String routeName = 'login_page';

	const LoginPage({super.key});

	@override
	Widget build(BuildContext context) {
  	return Scaffold(
    	body: Center(
      	child: AuthBackground(
					child: SingleChildScrollView(
						child: Column(
							children: [
								const SizedBox(
									height: 250
								),
								FormContainer(
									child: Column(
										children: [
											Text('Login', style: Theme.of(context).textTheme.headlineMedium),

											const SizedBox(height: 16),

											ChangeNotifierProvider(
												create: (_) => LoginFormProvider(),
												child: const _LoginForm()
											)
										],
									)
								),

								const SizedBox(height: 50),

								TextButton(
										onPressed: () => Navigator.pushReplacementNamed(context, RegisterPage.routeName),
										style: ButtonStyle(
												overlayColor: MaterialStateProperty.all(AppThemes.primaryColor.withOpacity(0.1)),
												shape: MaterialStateProperty.all(const StadiumBorder())
										),
										child: Padding(
											padding: const EdgeInsets.all(6.0),
											child: Text('Create new account',
													style: TextStyle(fontSize: 18, color: AppThemes.primaryColor.withOpacity(0.9))
											),
										)
								),

								const SizedBox(height: 50)
							],
						)
					)
				)
			),
		);
	}

}

class _LoginForm extends StatelessWidget {

	const _LoginForm({
		super.key,
	});

	@override
	Widget build(BuildContext context) {
		final loginFormProvider = Provider.of<LoginFormProvider>(context);

		return Form(
			key: loginFormProvider.formKey,
			autovalidateMode: AutovalidateMode.onUserInteraction,
			child: Column(
				children: [
					TextFormField(
						autocorrect: false,
						keyboardType: TextInputType.emailAddress,
						decoration: InputDecorations.authInputDecoration(
							labelText: 'Email',
							hintText: 'john.doe@mail.com',
							prefixIcon: Icons.alternate_email_sharp
						),
						onChanged: (value) => loginFormProvider.email = value,
						validator: LoginFormValidator.validateEmail
					),

					const SizedBox(height: 30),

					TextFormField(
						autocorrect: false,
						obscureText: true,
						keyboardType: TextInputType.emailAddress,
						decoration: InputDecorations.authInputDecoration(
							labelText: 'Password',
							hintText: '********',
							prefixIcon: Icons.lock_outline_sharp
						),
						onChanged: (value) => loginFormProvider.password = value,
						validator: LoginFormValidator.validatePassword
					),

					const SizedBox(height: 40),

					MaterialButton(
						height: 50,
						color: AppThemes.primaryColor,
						disabledColor: Colors.grey,
						elevation: 0,
						shape: RoundedRectangleBorder(
							borderRadius: BorderRadius.circular(20)
						),
						onPressed: !loginFormProvider.isLoading ? () async {
							FocusScope.of(context).unfocus();

							if (loginFormProvider.isValidForm()) {
								loginFormProvider.isLoading = true;

								final AuthService authService = Provider.of<AuthService>(context, listen: false);
								final String? errorMessage = await authService.loginUser(loginFormProvider.email, loginFormProvider.password);

								if (errorMessage == null) {
									Navigator.pushReplacementNamed(context, HomePage.routeName);
								} else {
									loginFormProvider.isLoading = false;
									NotificationsService.showSnackBar(errorMessage);
								}
							}
						} : null,
						child: Container(
							padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
							child: Text(
								!loginFormProvider.isLoading ? 'Enter' : 'Loading...',
								style: const TextStyle(color: Colors.white, fontSize: 16))
						)
					),

					const SizedBox(height: 20)
				]
			)
		);
	}

}