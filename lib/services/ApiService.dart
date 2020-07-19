
import 'package:fluttertoast/fluttertoast.dart';

import 'ApiResponse.dart';
import 'country_model.dart';
import 'state_model.dart';
import 'city_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {

  static const MY_URL = 'http://battuta.medunes.net/api/';
  static const KEY ='435c3933050485d621d3b3b5b8939095';

  Future<ApiResponse<List<CountryModel>>> getCountries() {
    return http.get(MY_URL+'country/all/?key='+KEY).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final countries = <CountryModel>[];
        for (var item in jsonData) {
          final country = CountryModel.fromMap(item);
          countries.add(country);
        }
        return ApiResponse<List<CountryModel>>(
            data: countries, error: false, errMessage: '');
      }
      return ApiResponse<List<CountryModel>>(
          data: null, error: true, errMessage: data.statusCode.toString());
    }).catchError((error) {
      return ApiResponse<List<CountryModel>>(
          data: null, error: true, errMessage: error.toString());
    });
  }

  Future<ApiResponse<List<StateModel>>> getStates(String code) {
    return http.get(MY_URL + "region/$code/all/?key="+KEY).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final states = <StateModel>[];
        for (var item in jsonData) {
          final state = StateModel.fromMap(item);
          states.add(state);
        }
        return ApiResponse<List<StateModel>>(
            data: states, error: false, errMessage: '');
      }
      return ApiResponse<List<StateModel>>(
          data: null, error: true, errMessage: 'An error occurred');
    }).catchError((error) {
      return ApiResponse<List<StateModel>>(
          data: null, error: true, errMessage: 'An error occurred');
    });
  }

  Future<ApiResponse<List<CityModel>>> getCities(String code,String region) {
    return http.get(MY_URL + 'city/$code/search/?region=${region.replaceAll(" ", "+")}&key='+KEY).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final cities = <CityModel>[];
        for (var item in jsonData) {
          final city = CityModel.fromMap(item);
          cities.add(city);
        }

        return ApiResponse<List<CityModel>>(
            data: cities, error: false, errMessage: '');
      }
      return ApiResponse<List<CityModel>>(
          data: null, error: true, errMessage: 'An error occurred');
    }).catchError((error) {
      return ApiResponse<List<CityModel>>(
          data: null, error: true, errMessage: 'An error occurred');
    });
  }

}
