import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_app/blocs/user/user_bloc.dart';
import 'package:tiktok_app/core/constants.dart';
import 'package:tiktok_app/features/profile/controller/get_current_user_by_token.dart';
import 'package:tiktok_app/models/User.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiktok_app/blocs/user/user_bloc.dart';

class SelectBirthdate extends StatefulWidget {
  const SelectBirthdate({super.key});

  @override
  State<SelectBirthdate> createState() => _SelectBirthdateState();
}

class _SelectBirthdateState extends State<SelectBirthdate> {
  int selectedDay = 1;
  int selectedMonth = 1;
  int selectedYear = 2000;
  Userapp? _currentUser;

  final List<int> _years = List.generate(
    100,
    (index) => DateTime.now().year - index,
  );
  final List<int> _months = List.generate(12, (index) => index + 1);
  List<int> _days = List.generate(31, (index) => index + 1);

  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateDateText();
    _fetchUser();
  }

  int _daysInMonth(int month, int year) {
    if (month == 2) {
      if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
        return 29;
      }
      return 28;
    }
    if ([4, 6, 9, 11].contains(month)) return 30;
    return 31;
  }

  void _updateDays() {
    int daysCount = _daysInMonth(selectedMonth, selectedYear);
    setState(() {
      _days = List.generate(daysCount, (index) => index + 1);
      if (selectedDay > daysCount) selectedDay = daysCount;
    });
  }

  void _updateDateText() {
    _dateController.text = '$selectedDay/$selectedMonth/$selectedYear';
  }

  void _fetchUser() async {
    Userapp? user = await GetUserByToken.getUserByToken();
    if (mounted) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (_currentUser == null) {
      return const Scaffold(
        backgroundColor: AppColors.trang,
        body: Center(child: CircularProgressIndicator()),
      );
    }

   return WillPopScope(
  onWillPop: () async {
    Navigator.pushReplacementNamed(
      context,
      '/Home',
      arguments: _currentUser,
    );
    return false; // Ngăn mặc định pop
  },
  child: Scaffold(
      backgroundColor: AppColors.trang,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.trang,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              '/Home',
              arguments: _currentUser,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "Ngày sinh của bạn là ngày nào?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.08,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Image.asset(
                  'assets/images/cake.png',
                  width: screenWidth * 0.25,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            const SizedBox(height: 24),

            TextField(
              readOnly: true,
              controller: _dateController,
              decoration: InputDecoration(
                hintText: 'Ngày sinh',
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// Cupertino Pickers
            SizedBox(
              height: 180,
              child: Row(
                children: [
                  /// Day Picker
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 80,
                      scrollController: FixedExtentScrollController(
                        initialItem:
                            (_days.contains(selectedDay)) ? selectedDay - 1 : 0,
                      ),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedDay = _days[index];
                          _updateDateText();
                        });
                      },
                      children:
                          _days
                              .map((day) => Center(child: Text('$day')))
                              .toList(),
                    ),
                  ),

                  /// Month Picker
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 80,
                      scrollController: FixedExtentScrollController(
                        initialItem:
                            (_months.contains(selectedMonth))
                                ? selectedMonth - 1
                                : 0,
                      ),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedMonth = _months[index];
                          _updateDays();
                          _updateDateText();
                        });
                      },
                      children:
                          _months
                              .map((month) => Center(child: Text('$month')))
                              .toList(),
                    ),
                  ),

                  /// Year Picker
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 80,
                      scrollController: FixedExtentScrollController(
                        initialItem:
                            (_years.contains(selectedYear))
                                ? _years.indexOf(selectedYear)
                                : 0,
                      ),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedYear = _years[index];
                          _updateDays();
                          _updateDateText();
                        });
                      },
                      children:
                          _years
                              .map((year) => Center(child: Text('$year')))
                              .toList(),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              
              child: ElevatedButton(
                onPressed: () async {
                  if (_currentUser != null) {
                    String newBirthdate =
                        '$selectedYear-$selectedMonth-$selectedDay';

                    BlocProvider.of<UserBloc>(context).add(
                      UpdateUserEvent(
                        Userapp(
                          id: _currentUser?.id,
                          birthdate: newBirthdate,
                        ),
                      ),
                    );
                    Navigator.pushReplacementNamed(
                      context,
                      '/Home',
                      arguments: _currentUser,
                    );
                  } else {
                    Navigator.pushReplacementNamed(context, '/register');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Lỗi khi cập nhật")),
                    );
                  }
                },

                child: const Text(
                  "Tiếp theo",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.trang,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dohong,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  
  }
}
