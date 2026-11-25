import 'package:flutter/material.dart';
import 'verification_code_screen.dart';

class _RoleOption {
  final String value; // 'creator' | 'workshop' | 'client'
  final String title;
  final String description;
  final IconData icon;

  const _RoleOption({
    required this.value,
    required this.title,
    required this.description,
    required this.icon,
  });
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();

  // Paso 1
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'creator';
  bool _obscurePassword = true;

  // Paso 2
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _workshopNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final Set<String> _selectedSpecialties = {'Denim'};
  bool _acceptedTerms = false;

  int _currentStep = 0;

  static final RegExp _emailRegex =
      RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,4}$');

  static const _creatorRole = _RoleOption(
    value: 'creator',
    title: 'Creador',
    description: 'Escaneo prendas, simulo patrones 3D/AR y cotizo diseños.',
    icon: Icons.view_in_ar_rounded,
  );

  static const _workshopRole = _RoleOption(
    value: 'workshop',
    title: 'Taller',
    description: 'Recibo fichas técnicas de corte y confecciono bajo pedido.',
    icon: Icons.content_cut_rounded,
  );

  static const _clientRole = _RoleOption(
    value: 'client',
    title: 'Cliente',
    description: 'Exploro el Lookbook y transformo mi ropa con talleres locales.',
    icon: Icons.eco_outlined,
  );

  final List<String> _availableSpecialties = const [
    'Denim',
    'Patchwork',
    'Bordado',
    'Sastrería',
    'Zurcido',
    'Lino y Algodón',
  ];

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _workshopNameController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  int _calculatePasswordStrength(String pwd) {
    if (pwd.isEmpty) return 0;
    int score = 0;
    if (pwd.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(pwd) && RegExp(r'[a-z]').hasMatch(pwd)) {
      score++;
    }
    if (RegExp(r'[0-9]').hasMatch(pwd)) score++;
    if (RegExp(r'[!@#\$&*~_\-\.]').hasMatch(pwd)) score++;
    return score.clamp(1, 4);
  }

  void _goToStep2() {
    FocusScope.of(context).unfocus();
    if (!_step1Key.currentState!.validate()) return;
    setState(() => _currentStep = 1);
  }

  String _getSelectedRoleTitle() {
    if (_selectedRole == 'workshop') return _workshopRole.title;
    if (_selectedRole == 'client') return _clientRole.title;
    return _creatorRole.title;
  }

  void _submitRegistration() {
    FocusScope.of(context).unfocus();
    if (!_step2Key.currentState!.validate()) return;

    if (_selectedRole == 'workshop' && _selectedSpecialties.isEmpty) {
      _showSnack('Selecciona al menos una especialidad textil para tu taller.');
      return;
    }

    if (!_acceptedTerms) {
      _showSnack('Debes aceptar los términos y el aviso de privacidad.');
      return;
    }

    // Navega a la verificación de correo con código OTP de 6 dígitos
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VerificationCodeScreen(
          email: _emailController.text.trim(),
          roleTitle: _getSelectedRoleTitle(),
          isPasswordReset: false,
        ),
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

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14.5),
      prefixIcon: Icon(icon, size: 19, color: const Color(0xFF7C8BA1)),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF6F9FC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD6E4F5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1D4ED8), width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDC2626)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWorkshop = _selectedRole == 'workshop';

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (_currentStep == 1) {
                            setState(() => _currentStep = 0);
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
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
                      Text(
                        'Paso ${_currentStep + 1} de 2',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF526077),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 3.5,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1D4ED8), Color(0xFF0EA5E9)],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 240),
                          height: 3.5,
                          decoration: BoxDecoration(
                            gradient: _currentStep == 1
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFF1D4ED8),
                                      Color(0xFF0EA5E9),
                                    ],
                                  )
                                : null,
                            color: _currentStep == 1
                                ? null
                                : const Color(0xFFE2ECF7),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Text(
                    _currentStep == 0
                        ? 'Crea tu cuenta'
                        : isWorkshop
                            ? 'Datos de tu taller'
                            : 'Completa tu perfil',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      color: Color(0xFF0A1628),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _currentStep == 0
                        ? 'Elige tu perfil dentro de HoloWear y configura tu acceso.'
                        : isWorkshop
                            ? 'Esta información permitirá que creadores y clientes encuentren tu taller.'
                            : 'Indica tu ciudad base para conectarte con talleres cercanos.',
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Color(0xFF526077),
                    ),
                  ),

                  const SizedBox(height: 24),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 240),
                    child: _currentStep == 0
                        ? _buildStep1Form()
                        : _buildStep2Form(isWorkshop),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep1Form() {
    final strength = _calculatePasswordStrength(_passwordController.text);
    final strengthLabels = ['', 'Débil', 'Aceptable', 'Segura', 'Muy segura'];
    final strengthColors = [
      Colors.transparent,
      const Color(0xFFDC2626),
      const Color(0xFFD97706),
      const Color(0xFF0284C7),
      const Color(0xFF16A34A),
    ];

    return Form(
      key: _step1Key,
      child: Column(
        key: const ValueKey('step1'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Tu rol en HoloWear',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 10),

          // 2 tarjetas principales lado a lado (Creador / Taller)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _buildPrimaryRoleCard(_creatorRole)),
                const SizedBox(width: 12),
                Expanded(child: _buildPrimaryRoleCard(_workshopRole)),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Tarjeta horizontal limpia para Cliente
          _buildSecondaryRoleCard(_clientRole),

          const SizedBox(height: 22),

          const Text(
            'Nombre completo',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 7),
          TextFormField(
            controller: _fullNameController,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(fontSize: 15, color: Color(0xFF0A1628)),
            validator: (v) {
              if ((v ?? '').trim().length < 3) {
                return 'Ingresa tu nombre y apellido (mín. 3 caracteres)';
              }
              return null;
            },
            decoration: _inputDecoration(
              hint: 'Ej. Ana Sofía Herrera',
              icon: Icons.person_outline_rounded,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Correo electrónico',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 7),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 15, color: Color(0xFF0A1628)),
            validator: (v) {
              final text = (v ?? '').trim();
              if (text.isEmpty || !_emailRegex.hasMatch(text)) {
                return 'Ingresa un correo electrónico válido';
              }
              return null;
            },
            decoration: _inputDecoration(
              hint: 'nombre@correo.com',
              icon: Icons.mail_outline_rounded,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Contraseña',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 7),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: const TextStyle(fontSize: 15, color: Color(0xFF0A1628)),
            validator: (v) {
              final text = v ?? '';
              if (text.length < 8 ||
                  !RegExp(r'[A-Za-z]').hasMatch(text) ||
                  !RegExp(r'[0-9]').hasMatch(text)) {
                return 'Usa mín. 8 caracteres con letras y números';
              }
              return null;
            },
            decoration: _inputDecoration(
              hint: 'Mínimo 8 caracteres',
              icon: Icons.lock_outline_rounded,
              suffix: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: const Color(0xFF7C8BA1),
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
          ),

          if (_passwordController.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                ...List.generate(4, (i) {
                  return Expanded(
                    child: Container(
                      height: 3,
                      margin: EdgeInsets.only(right: i < 3 ? 5 : 0),
                      decoration: BoxDecoration(
                        color: i < strength
                            ? strengthColors[strength]
                            : const Color(0xFFE2ECF7),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 10),
                Text(
                  strengthLabels[strength],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: strengthColors[strength],
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 24),

          Container(
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF1D4ED8), Color(0xFF0284C7)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x2E1D4ED8),
                  blurRadius: 14,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _goToStep2,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continuar',
                    style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryRoleCard(_RoleOption role) {
    final selected = _selectedRole == role.value;

    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFEFF6FF), Color(0xFFFFFFFF)],
                )
              : null,
          color: selected ? null : const Color(0xFFF6F9FC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? const Color(0xFF1D4ED8)
                : const Color(0xFFD6E4F5),
            width: selected ? 1.8 : 1.0,
          ),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x1A1D4ED8),
                    blurRadius: 14,
                    offset: Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: selected
                        ? const LinearGradient(
                            colors: [Color(0xFF1D4ED8), Color(0xFF0284C7)],
                          )
                        : null,
                    color: selected ? null : const Color(0xFFE8F1FC),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    role.icon,
                    size: 19,
                    color: selected
                        ? Colors.white
                        : const Color(0xFF1D4ED8),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF1D4ED8)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF1D4ED8)
                          : const Color(0xFFCBD5E1),
                      width: 1.5,
                    ),
                  ),
                  child: selected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 13,
                          color: Colors.white,
                        )
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              role.title,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0A1628),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              role.description,
              style: const TextStyle(
                fontSize: 12,
                height: 1.35,
                color: Color(0xFF526077),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryRoleCard(_RoleOption role) {
    final selected = _selectedRole == role.value;

    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFFEFF6FF), Color(0xFFFFFFFF)],
                )
              : null,
          color: selected ? null : const Color(0xFFF6F9FC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? const Color(0xFF1D4ED8)
                : const Color(0xFFD6E4F5),
            width: selected ? 1.8 : 1.0,
          ),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x1A1D4ED8),
                    blurRadius: 14,
                    offset: Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                gradient: selected
                    ? const LinearGradient(
                        colors: [Color(0xFF1D4ED8), Color(0xFF0284C7)],
                      )
                    : null,
                color: selected ? null : const Color(0xFFE8F1FC),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(
                role.icon,
                size: 19,
                color: selected ? Colors.white : const Color(0xFF1D4ED8),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0A1628),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    role.description,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.3,
                      color: Color(0xFF526077),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF1D4ED8)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? const Color(0xFF1D4ED8)
                      : const Color(0xFFCBD5E1),
                  width: 1.5,
                ),
              ),
              child: selected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 13,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2Form(bool isWorkshop) {
    final ctaLabel = _selectedRole == 'workshop'
        ? 'Registrar Taller'
        : _selectedRole == 'client'
            ? 'Crear cuenta de Cliente'
            : 'Crear cuenta de Creador';

    return Form(
      key: _step2Key,
      child: Column(
        key: const ValueKey('step2'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Ciudad',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _cityController,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(fontSize: 15, color: Color(0xFF0A1628)),
            validator: (v) {
              if ((v ?? '').trim().length < 3) {
                return 'Indica tu ciudad base';
              }
              return null;
            },
            decoration: _inputDecoration(
              hint: 'Ej. Valle de Santiago, Gto.',
              icon: Icons.location_city_outlined,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            isWorkshop
                ? 'Teléfono o WhatsApp del taller'
                : 'Teléfono o WhatsApp (opcional)',
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(fontSize: 15, color: Color(0xFF0A1628)),
            validator: (v) {
              final digits = (v ?? '').replaceAll(RegExp(r'\D'), '');
              if (isWorkshop && digits.length < 10) {
                return 'Ingresa un número de contacto a 10 dígitos';
              }
              if (!isWorkshop && digits.isNotEmpty && digits.length < 10) {
                return 'Si agregas teléfono, incluye los 10 dígitos';
              }
              return null;
            },
            decoration: _inputDecoration(
              hint: '456 123 4567',
              icon: Icons.phone_outlined,
            ),
          ),

          if (isWorkshop) ...[
            const SizedBox(height: 22),
            const Divider(color: Color(0xFFE2ECF7)),
            const SizedBox(height: 18),

            const Text(
              'Nombre comercial del taller',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _workshopNameController,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(fontSize: 15, color: Color(0xFF0A1628)),
              validator: (v) {
                if (isWorkshop && (v ?? '').trim().length < 3) {
                  return 'Ingresa el nombre de tu taller o sastrería';
                }
                return null;
              },
              decoration: _inputDecoration(
                hint: 'Ej. Sastrería Méndez',
                icon: Icons.storefront_outlined,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Dirección o zona de entrega',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _addressController,
              style: const TextStyle(fontSize: 15, color: Color(0xFF0A1628)),
              validator: (v) {
                if (isWorkshop && (v ?? '').trim().length < 5) {
                  return 'Indica la dirección o zona de recepción';
                }
                return null;
              },
              decoration: _inputDecoration(
                hint: 'Calle, número y colonia',
                icon: Icons.place_outlined,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Especialidades textiles',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableSpecialties.map((spec) {
                final active = _selectedSpecialties.contains(spec);
                return FilterChip(
                  label: Text(spec),
                  selected: active,
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        _selectedSpecialties.add(spec);
                      } else {
                        _selectedSpecialties.remove(spec);
                      }
                    });
                  },
                  selectedColor: const Color(0xFFEFF6FF),
                  backgroundColor: const Color(0xFFF6F9FC),
                  checkmarkColor: const Color(0xFF1D4ED8),
                  labelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                    color: active
                        ? const Color(0xFF1D4ED8)
                        : const Color(0xFF526077),
                  ),
                  side: BorderSide(
                    color: active
                        ? const Color(0xFF1D4ED8)
                        : const Color(0xFFD6E4F5),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 18),

            const Text(
              'Descripción o maquinaria (opcional)',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLines: 2,
              style: const TextStyle(fontSize: 14.5, color: Color(0xFF0A1628)),
              decoration: _inputDecoration(
                hint: 'Ej. Recta industrial, overlock y mezclilla',
                icon: Icons.notes_rounded,
              ),
            ),
          ],

          const SizedBox(height: 18),

          InkWell(
            onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: Checkbox(
                      value: _acceptedTerms,
                      activeColor: const Color(0xFF1D4ED8),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      onChanged: (v) =>
                          setState(() => _acceptedTerms = v ?? false),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Acepto los Términos de Uso y el Aviso de Privacidad sobre el análisis de prendas.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: Color(0xFF526077),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 22),

          Container(
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF1D4ED8), Color(0xFF0284C7)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x2E1D4ED8),
                  blurRadius: 14,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _submitRegistration,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                ctaLabel,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}