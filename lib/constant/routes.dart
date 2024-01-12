import 'package:flutter/material.dart';
import 'package:salsel_express/view/home_view.dart';
import 'package:salsel_express/view/job_detail_view.dart';
import 'package:salsel_express/view/login_view.dart';
import 'package:salsel_express/view/show_jobs_view.dart';
import 'package:salsel_express/view/show_tickets_view.dart';
import 'package:salsel_express/view/ticket_detail_view.dart';

const String loginRoute = '/login';
const String homeRoute = '/home';
const String showTickets = '/showTickets';
const String ticketDetail = '/ticketDetail';
const String showJobs = '/showJobs';
const String jobDetail = '/jobDetail';

final Map<String, WidgetBuilder> routes = {
  loginRoute: (context) => const LoginView(),
  homeRoute: (context) => const HomeView(),
  showTickets: (context) => const ShowTicketsView(),
  ticketDetail: (context) => const TicketDetailView(ticketDetails: {}, ticketTitle: '', hardcodedData: {},),
  showJobs: (context) => const ShowJobsView(),
  jobDetail: (context) => const JobDetailView(jobDetails: {}, hardcodedData: {}, jobTitle: '',),
};
