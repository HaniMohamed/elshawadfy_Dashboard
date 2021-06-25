import 'package:admin/responsive.dart';
import 'package:admin/shared/constants.dart';
import 'package:admin/ui/screens/dashboard/components/my_fields.dart';
import 'package:flutter/material.dart';

import '../../widgtes/header.dart';

import 'components/recent_files.dart';
import 'components/storage_details.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(
                title: "Dashboard",
              ),
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        MyFiles(),
                        SizedBox(height: defaultPadding),
                        RecentFiles(),
                        if (Responsive.isMobile(context))
                          SizedBox(height: defaultPadding),
                        if (Responsive.isMobile(context)) StarageDetails(),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context))
                    SizedBox(width: defaultPadding),
                  // On Mobile means if the screen is less than 850 we dont want to show it
                  if (!Responsive.isMobile(context))
                    Expanded(
                      flex: 2,
                      child: StarageDetails(),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
