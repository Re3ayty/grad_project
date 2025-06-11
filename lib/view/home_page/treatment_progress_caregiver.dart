import 'package:flutter/material.dart';

class PatientTreatmentProgress extends StatefulWidget {
  @override
  State<PatientTreatmentProgress> createState() => _PatientTreatmentProgressState();
}

class _PatientTreatmentProgressState extends State<PatientTreatmentProgress>
    with SingleTickerProviderStateMixin {
  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<int> dates = [6, 7, 8, 9, 10, 11, 12]; // Example week

  final Color highlightColor = Color.fromRGBO(125, 158, 248, 1);

  late int today;
  int? selectedDay;
  String selectedPeriod = 'This week';

  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    today = DateTime.now().day;

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _progressAnimation = Tween<double>(begin: 0, end: 0.75).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFD2E4F5),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.brightness_7_rounded, color: highlightColor),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Patient treatment progress',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                '75%',
                style: TextStyle(
                  color: highlightColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Animated Progress Bar
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _progressAnimation.value,
                  minHeight: 8,
                  backgroundColor: highlightColor.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(highlightColor),
                ),
              );
            },
          ),

          SizedBox(height: 16),

          // Period Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildEvalButton('This week'),
              _buildEvalButton('This month'),
              _buildEvalButton('This year'),
            ],
          ),

          SizedBox(height: 16),

          // Dynamic View
          if (selectedPeriod == 'This year')
            _buildYearView()
          else if (selectedPeriod == 'This month')
            _buildMonthView()
          else
            _buildWeekView(),
        ],
      ),
    );
  }

  Widget _buildEvalButton(String label) {
    final bool isSelected = selectedPeriod == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPeriod = label;
          selectedDay = null;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? highlightColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: highlightColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: highlightColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildWeekView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final int dayDate = dates[index];
        final bool isToday = dayDate == today;
        final bool isPast = dayDate < today;
        final bool isSelected = selectedDay == dayDate;

        return GestureDetector(
          onTap: () {
            if (isPast || isToday) {
              setState(() => selectedDay = dayDate);
            }
          },
          child: Column(
            children: [
              Text(days[index], style: TextStyle(fontSize: 12, color: Colors.grey)),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected || isToday
                      ? highlightColor
                      : Colors.transparent,
                  border: !isSelected && isPast
                      ? Border.all(color: highlightColor, width: 2)
                      : null,
                ),
                child: Text(
                  dayDate.toString(),
                  style: TextStyle(
                    color: isSelected || isToday
                        ? Colors.white
                        : isPast
                        ? highlightColor
                        : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMonthView() {
    final List<int> allDays = List.generate(28, (index) => index + 1);

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allDays.length,
        itemBuilder: (context, index) {
          final int dayDate = allDays[index];
          final bool isToday = dayDate == today;
          final bool isPast = dayDate < today;
          final bool isSelected = selectedDay == dayDate;

          return GestureDetector(
            onTap: () {
              if (isPast || isToday) {
                setState(() => selectedDay = dayDate);
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                children: [
                  Text("Day", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected || isToday
                          ? highlightColor
                          : Colors.transparent,
                      border: !isSelected && isPast
                          ? Border.all(color: highlightColor, width: 2)
                          : null,
                    ),
                    child: Text(
                      dayDate.toString(),
                      style: TextStyle(
                        color: isSelected || isToday
                            ? Colors.white
                            : isPast
                            ? highlightColor
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildYearView() {
    final int totalWeeks = 12;

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemCount: totalWeeks,
      itemBuilder: (context, index) {
        final int weekNumber = index + 1;
        final bool isSelected = selectedDay == weekNumber;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDay = weekNumber;
            });
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? highlightColor : Colors.transparent,
              border: Border.all(color: highlightColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Month $weekNumber',
              style: TextStyle(
                color: isSelected ? Colors.white : highlightColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
