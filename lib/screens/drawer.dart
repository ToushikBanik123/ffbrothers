import 'package:ff/Provider/AppProvider.dart';
import 'package:ff/screens/privacy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bidHistoryDrawer.dart';
import 'login.dart';

class NavDrawer extends StatelessWidget {
  // Function to handle logout
  Future<void> logoutUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('savedUser'); // Remove the saved user information
    Provider.of<AppProvider>(context, listen: false).setUser(null); // Clear the user in the provider
    // You can navigate back to the login page or another appropriate screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Replace with your login page
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context,provider,child){
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(provider.user!.username, style: TextStyle(fontSize: 18.w)),
              accountEmail: Text(provider.user!.phone, style: TextStyle(fontSize: 15.w)),
              // currentAccountPicture: CircleAvatar(
              //   backgroundImage: AssetImage("assets/images/dp.jpg"),
              //   backgroundColor: Colors.blue.shade100,
              // ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.red, Colors.black],
                ),
              ),
            ),
            SizedBox(height: 10.h,),
            ListTile(
              leading: Icon(Icons.home, size: 25.w),
              title: Text('Home', style: TextStyle(fontSize: 15.sp),),
              trailing: Icon(Icons.arrow_forward_ios, size: 18.w),
              onTap: () => {
                //Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Home_Page()),
                // )
              },
            ),
            ListTile(
              leading: Icon(Icons.lock, size: 25.w),
              title: Text('Change Password', style: TextStyle(fontSize: 15.sp),),
              trailing: Icon(Icons.arrow_forward_ios, size: 18.w),
              // onTap: () => {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => MockTest()),
              //   )
              // },
            ),
            ListTile(
              leading: Icon(Icons.history_toggle_off, size: 25.w),
              title: Text('Bid History', style: TextStyle(fontSize: 15.sp),),
              trailing: Icon(Icons.arrow_forward_ios, size: 18.w),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => bidHistoryDrawer()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history, size: 25.w),
              title: Text('Winning History', style: TextStyle(fontSize: 15.sp),),
              trailing: Icon(Icons.arrow_forward_ios, size: 18.w),
              onTap: () => {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => TeamPage()),
                // )
              },
            ),
            ListTile(
              leading: Icon(Icons.games, size: 25.w),
              title: Text('Game Rate', style: TextStyle(fontSize: 15.sp),),
              trailing: Icon(Icons.arrow_forward_ios, size: 18.w),
              onTap: () => {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => JobPage()),
                // )
              },
            ),
            ListTile(
              leading: Icon(Icons.play_arrow, size: 25.w),
              title: Text('How To Play', style: TextStyle(fontSize: 15.sp),),
              trailing: Icon(Icons.arrow_forward_ios, size: 18.w),
              onTap: () => {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => ContactPage()),
                // )
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_phone_outlined, size: 25.w),
              title: Text('Contact Us', style: TextStyle(fontSize: 15.sp),),
              trailing: Icon(Icons.arrow_forward_ios, size: 18.w),
              // onTap: () => {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => Home_Page()),
              //   )
              // },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip_outlined, size: 25.w),
              title: Text('Privacy Policy', style: TextStyle(fontSize: 15.sp),),
              trailing: Icon(Icons.arrow_forward_ios, size: 18.w),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
                )
              },
            ),
            ListTile(
              leading: Icon(Icons.share, size: 25.w),
              title: Text('Share', style: TextStyle(fontSize: 15.sp),),
              trailing: Icon(Icons.arrow_forward_ios, size: 18.w),
              onTap: () => {},
            ),
            ListTile(
              leading: Icon(Icons.star, size: 25.w),
              title: Text('Rate App', style: TextStyle(fontSize: 15.sp),),
              trailing: Icon(Icons.arrow_forward_ios, size: 18.w),
              onTap: () => {},
            ),
            ListTile(
              leading: Icon(Icons.logout, size: 25.w),
              title: Text('Logout', style: TextStyle(fontSize: 15.sp),),
              trailing: Icon(Icons.arrow_forward_ios, size: 18.w),
              onTap: () => {
                logoutUser(context),
              },
            ),
            SizedBox(height: 50.sp,),
          ],
        ),
      );
    });
  }
}