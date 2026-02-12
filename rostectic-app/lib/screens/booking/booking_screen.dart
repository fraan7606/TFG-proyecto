import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../providers/booking_provider.dart';
import '../../models/service_model.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<BookingProvider>().fetchServices());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _currentStep > 0 ? _prevStep : () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;
          
          return Row(
            children: [
              // Contenido Principal
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildStepHeader(),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _ServiceSelectionStep(onNext: _nextStep),
                          _DateTimeSelectionStep(onNext: _nextStep),
                          _ConfirmationFinalStep(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Sidebar "Tu Pedido" (Solo en pantallas anchas)
              if (isWide && _currentStep > 0)
                Container(
                  width: 350,
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: Colors.grey[200]!)),
                    color: const Color(0xFFF9FAFB),
                  ),
                  child: const _BookingSummarySidebar(),
                ),
            ],
          );
        },
      ),
      // Resumen inferior para móvil
      bottomNavigationBar: MediaQuery.of(context).size.width <= 900 && _currentStep > 0
          ? const _MobileBookingSummary()
          : null,
    );
  }

  Widget _buildStepHeader() {
    String title = '';
    switch (_currentStep) {
      case 0: title = 'Seleccionar servicio'; break;
      case 1: title = 'Seleccionar fecha y hora'; break;
      case 2: title = 'Confirmar reserva'; break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(3, (index) {
              bool isActive = index <= _currentStep;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                  decoration: BoxDecoration(
                    color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey[200],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }
}

// --- SIDEBAR RESUMEN (WEB/TABLET) ---
class _BookingSummarySidebar extends StatelessWidget {
  const _BookingSummarySidebar();

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, provider, child) {
        final service = provider.selectedService;
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tu pedido', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              if (service != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(service.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                          Text('${service.price}€', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text('${service.durationMinutes}min', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                      ),
                      const Divider(height: 24),
                      const Text('Empleado disponible', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: provider.selectedSpecialist?.id == '0' ? Colors.grey[200] : Theme.of(context).colorScheme.primary,
                            child: const Icon(Icons.person, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(provider.selectedSpecialist?.name ?? 'Cualquiera', style: const TextStyle(fontSize: 14)),
                              Text(provider.selectedSpecialist?.role ?? '', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('${service?.price ?? 0} €', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: provider.selectedTime != null ? () {
                    // Si ya estamos en el último paso, confirmamos
                    // En este sidebar solo mostramos el botón si es web
                  } : null,
                  child: const Text('Continuar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// --- RESUMEN MOVIL (BOTTOM) ---
class _MobileBookingSummary extends StatelessWidget {
  const _MobileBookingSummary();

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  Text('${provider.selectedService?.price ?? 0} €', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: provider.selectedTime != null ? () {
                   // Accion de continuar manejada por el PageView o similar
                } : null,
                child: const Text('Continuar'),
              ),
            ],
          ),
        );
      },
    );
  }
}

// --- PASO 1: SERVICIOS CON ESTILO PREMIUM ---
class _ServiceSelectionStep extends StatelessWidget {
  final VoidCallback onNext;
  const _ServiceSelectionStep({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) return const Center(child: CircularProgressIndicator());
        
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          itemCount: provider.services.length,
          itemBuilder: (context, index) {
            final service = provider.services[index];
            return InkWell(
              onTap: () {
                provider.selectService(service);
                onNext();
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(service.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(service.description ?? '', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                          const SizedBox(height: 8),
                          Text('${service.durationMinutes} min', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text('${service.price} €', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// --- PASO 2: CALENDARIO Y SLOTS ESTILO BOOKSY ---
class _DateTimeSelectionStep extends StatefulWidget {
  final VoidCallback onNext;
  const _DateTimeSelectionStep({required this.onNext});

  @override
  State<_DateTimeSelectionStep> createState() => _DateTimeSelectionStepState();
}

class _DateTimeSelectionStepState extends State<_DateTimeSelectionStep> {
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendario Custom
              TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 90)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(provider.selectedDate, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() => _focusedDay = focusedDay);
                  provider.selectDate(selectedDay);
                },
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: false,
                  titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    // Simulación de disponibilidad para los puntos de colores
                    // En una app real, esto vendría de una API
                    final day = date.day;
                    Color markerColor = Colors.transparent;
                    if (day % 3 == 0) markerColor = Colors.green;
                    else if (day % 4 == 0) markerColor = Colors.orange;
                    else if (day % 5 == 0) markerColor = Colors.amber;

                    if (markerColor == Colors.transparent) return null;

                    return Positioned(
                      bottom: 4,
                      child: Container(
                        width: 12,
                        height: 3,
                        decoration: BoxDecoration(
                          color: markerColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  },
                ),
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
                  todayDecoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), shape: BoxShape.circle, border: Border.all(color: Theme.of(context).colorScheme.primary)),
                  todayTextStyle: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                  outsideDaysVisible: false,
                  defaultDecoration: const BoxDecoration(shape: BoxShape.circle),
                  weekendDecoration: const BoxDecoration(shape: BoxShape.circle),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.grey),
                  weekendStyle: TextStyle(color: Colors.grey),
                ),
              ),
              
              const SizedBox(height: 24),
              const Text('Empleados disponibles', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: provider.specialists.map((spec) => _SpecialistAvatar(
                    specialist: spec,
                    isSelected: provider.selectedSpecialist?.id == spec.id,
                    onTap: () => provider.selectSpecialist(spec),
                  )).toList(),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Secciones de tiempo
              _TimeSectionTitle(title: 'Mañana', count: provider.morningSlots.length),
              _buildSlotGrid(context, provider.morningSlots, provider),
              
              const SizedBox(height: 24),
              _TimeSectionTitle(title: 'Mediodía', count: provider.noonSlots.length),
              _buildSlotGrid(context, provider.noonSlots, provider),
              
              const SizedBox(height: 24),
              _TimeSectionTitle(title: 'Tarde', count: provider.afternoonSlots.length),
              _buildSlotGrid(context, provider.afternoonSlots, provider),
              
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSlotGrid(BuildContext context, List<String> slots, BookingProvider provider) {
    if (slots.isEmpty) return const Padding(padding: EdgeInsets.only(top: 8), child: Text('No disponible', style: TextStyle(color: Colors.grey, fontSize: 13)));
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: slots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 2.5,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemBuilder: (context, index) {
        final time = slots[index];
        final isSelected = provider.selectedTime == time;
        return InkWell(
          onTap: () {
            provider.selectTime(time);
            // Si es movil, mostrar scroll o boton continuar
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.05) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent, width: 2),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SpecialistAvatar extends StatelessWidget {
  final Specialist specialist;
  final bool isSelected;
  final VoidCallback onTap;

  const _SpecialistAvatar({required this.specialist, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey[200],
                  child: const Icon(Icons.person, color: Colors.white, size: 30),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                    child: const Icon(Icons.check, size: 14, color: Colors.white),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              specialist.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.black : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeSectionTitle extends StatelessWidget {
  final String title;
  final int count;
  const _TimeSectionTitle({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(width: 8),
        Text('($count)', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
      ],
    );
  }
}

// --- PASO 3: CONFIRMACION FINAL ---
class _ConfirmationFinalStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const Icon(Icons.verified, size: 100, color: Colors.green),
              const SizedBox(height: 32),
              const Text('¡Todo listo!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Text(
                'Confirma los detalles de tu cita antes de finalizar.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 48),
              if (provider.isLoading)
                const CircularProgressIndicator()
              else
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      final success = await provider.bookAppointment();
                      if (success && context.mounted) {
                        _showSuccess(context);
                      }
                    },
                    child: const Text('Confirmar Reserva'),
                  ),
                ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }

  void _showSuccess(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 24),
            const Text('¡Cita Confirmada!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Te hemos enviado un email con los detalles de tu reserva.', textAlign: TextAlign.center),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text('Aceptar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
