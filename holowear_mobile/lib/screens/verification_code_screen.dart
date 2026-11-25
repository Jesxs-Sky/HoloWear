import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String email;
  final String? roleTitle;
  final bool isPasswordReset;

  const VerificationCodeScreen({
    super.key,
    required this.email,
    this.roleTitle,
    this.isPasswordReset = false,
  });

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final List<TextEditingController> _digitControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _digitNodes = List.generate(6, (_) => FocusNode());

  final _newPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _isVerifying = false;

  int _secondsRemaining = 60;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _digitNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (final c in _digitControllers) {
      c.dispose();
    }
    for (final n in _digitNodes) {
      n.dispose();
    }
    _newPasswordController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _resendTimer?.cancel();
    setState(() => _secondsRemaining = 60);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
        if (mounted) setState(() => _secondsRemaining = 0);
      } else {
        if (mounted) setState(() => _secondsRemaining--);
      }
    });
  }

  String get _currentCode =>
      _digitControllers.map((c) => c.text.trim()).join();

  void _onDigitChanged(int index, String value) {
    if (value.length > 1) {
      final clean = value.replaceAll(RegExp(r'\D'), '');
      for (int i = 0; i < 6; i++) {
        _digitControllers[i].text = i < clean.length ? clean[i] : '';
      }
      final nextIndex = clean.length >= 6 ? 5 : clean.length;
      _digitNodes[nextIndex].requestFocus();
      setState(() {});
      return;
    }

    if (value.isNotEmpty && index < 5) {
      _digitNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _digitNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  void _handleResendCode() {
    if (_secondsRemaining > 0) return;
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Nuevo código enviado a ${widget.email}'),
        backgroundColor: const Color(0xFF0A1628),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _verifyAndContinue() async {
    FocusScope.of(context).unfocus();
    final code = _currentCode;

    if (code.length < 6) {
      _showSnack('Ingresa los 6 dígitos enviados a tu correo.');
      return;
    }

    if (widget.isPasswordReset) {
      final pwd = _newPasswordController.text;
      if (pwd.length < 8 ||
          !RegExp(r'[A-Za-z]').hasMatch(pwd) ||
          !RegExp(r'[0-9]').hasMatch(pwd)) {
        _showSnack(
          'La nueva contraseña debe tener mín. 8 caracteres, letras y números.',
        );
        return;
      }
    }

    setState(() => _isVerifying = true);
    await Future.delayed(const Duration(milliseconds: 550));
    if (!mounted) return;
    setState(() => _isVerifying = false);

    final title = widget.isPasswordReset
        ? 'Contraseña actualizada'
        : 'Correo verificado';
    final body = widget.isPasswordReset
        ? 'Tu nueva contraseña ha sido guardada. Ya puedes iniciar sesión con tu cuenta.'
        : 'Tu cuenta como ${widget.roleTitle ?? 'Usuario'} (${widget.email}) está verificada y lista.';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.verified_rounded, color: Color(0xFF16A34A)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0A1628),
                ),
              ),
            ),
          ],
        ),
        content: Text(
          body,
          style: const TextStyle(
            fontSize: 14,
            height: 1.45,
            color: Color(0xFF526077),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text(
              'Ir a Iniciar Sesión',
              style: TextStyle(
                color: Color(0xFF1D4ED8),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF0A1628),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCodeComplete = _currentCode.length == 6;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(26, 16, 26, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 390),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFF6F9FC),
                        side: const BorderSide(color: Color(0xFFD6E4F5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        size: 20,
                        color: Color(0xFF0A1628),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Center(
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFEFF6FF), Color(0xFFF6F9FC)],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFD6E4F5)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x140EA5E9),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.mark_email_read_outlined,
                        size: 32,
                        color: Color(0xFF1D4ED8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    widget.isPasswordReset
                        ? 'Restablece tu contraseña'
                        : 'Verifica tu correo',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      color: Color(0xFF0A1628),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      text: 'Enviamos un código de 6 dígitos a\n',
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.45,
                        color: Color(0xFF526077),
                      ),
                      children: [
                        TextSpan(
                          text: widget.email,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0A1628),
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 28),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      final hasValue = _digitControllers[index].text.isNotEmpty;
                      return SizedBox(
                        width: 48,
                        height: 56,
                        child: TextField(
                          controller: _digitControllers[index],
                          focusNode: _digitNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 6,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0A1628),
                          ),
                          onChanged: (val) => _onDigitChanged(index, val),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: hasValue
                                ? const Color(0xFFEFF6FF)
                                : const Color(0xFFF6F9FC),
                            contentPadding: EdgeInsets.zero,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: hasValue
                                    ? const Color(0xFF1D4ED8)
                                    : const Color(0xFFD6E4F5),
                                width: hasValue ? 1.5 : 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF0284C7),
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  if (widget.isPasswordReset) ...[
                    const SizedBox(height: 22),
                    const Text(
                      'Nueva contraseña',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _newPasswordController,
                      obscureText: _obscureNewPassword,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF0A1628),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Mínimo 8 caracteres (letras y números)',
                        hintStyle: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_reset_rounded,
                          size: 20,
                          color: Color(0xFF7C8BA1),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNewPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20,
                            color: const Color(0xFF7C8BA1),
                          ),
                          onPressed: () => setState(
                            () => _obscureNewPassword = !_obscureNewPassword,
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF6F9FC),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFD6E4F5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF1D4ED8),
                            width: 1.6,
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 28),

                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: isCodeComplete
                            ? const [Color(0xFF1D4ED8), Color(0xFF0284C7)]
                            : const [Color(0xFF93C5FD), Color(0xFF7DD3FC)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isCodeComplete
                          ? const [
                              BoxShadow(
                                color: Color(0x2E1D4ED8),
                                blurRadius: 14,
                                offset: Offset(0, 5),
                              ),
                            ]
                          : null,
                    ),
                    child: ElevatedButton(
                      onPressed: _isVerifying ? null : _verifyAndContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isVerifying
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              widget.isPasswordReset
                                  ? 'Confirmar nueva contraseña'
                                  : 'Verificar y activar cuenta',
                              style: const TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: _secondsRemaining > 0
                        ? Text(
                            'Reenviar código en 00:${_secondsRemaining.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 13.5,
                              color: Color(0xFF7C8BA1),
                            ),
                          )
                        : TextButton(
                            onPressed: _handleResendCode,
                            child: const Text(
                              '¿No recibiste el correo? Reenviar código',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1D4ED8),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}