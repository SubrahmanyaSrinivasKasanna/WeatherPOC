//
//  LocalTestData.swift
//  WeatherApp
//
//  Created by Srinivas Kasanna on 12/27/17.
//  Copyright © 2017 asdf. All rights reserved.
//

import Foundation

public let kMockJsonValidResponse : JSON = [
    "main": [
        "humidity" : "93",
        "pressure" : "1027",
        "temp" : "276.29",
        "temp_max" : "277.15",
        "temp_min" : "276.15",
    ], "name": "Dallas",
       "id": "4684888",
       "coord": [
        "lat" : "32.78",
        "lon" : "-96.8",
    ], "weather": [
        [
            "description" : "drizzle",
            "icon" : "09d",
            "id" : "301",
            "main" : "Drizzle",
            ]
    ],
       "clouds":
        [
            "all" : "90",
    ],
       "dt": "1514327100",
       "base": "stations",
       "sys": [
        "country" : "US",
        "id" : "2592",
        "message" : "0.0061",
        "sunrise" : "1514294897",
        "sunset" : "1514330921",
        "type" : "1",
    ], "cod": "200", "visibility": "6437", "wind": [
        "deg" : "30",
        "speed" : "3.6",
    ]] as JSON ;

public let kMockEmptyJson : JSON = [:];

public let kMockJsonInValidWeatherMissing : JSON = [
    "main": [
        "humidity" : "93",
        "pressure" : "1027",
        "temp" : "276.29",
        "temp_max" : "277.15",
        "temp_min" : "276.15",
    ], "name": "Dallas",
       "id": "4684888",
       "coord": [
        "lat" : "32.78",
        "lon" : "-96.8",
    ],
       "clouds":
        [
            "all" : "90",
    ],
       "dt": "1514327100",
       "base": "stations",
       "sys": [
        "country" : "US",
        "id" : "2592",
        "message" : "0.0061",
        "sunrise" : "1514294897",
        "sunset" : "1514330921",
        "type" : "1",
    ], "cod": "200", "visibility": "6437", "wind": [
        "deg" : "30",
        "speed" : "3.6",
    ]] as JSON ;

public let kMockJsonInValidValues : JSON = [
    "main": [
        "humidity" : "93",
        "pressure" : "1027",
        "temp" : "276.29",
        "temp_max" : "277.15",
        "temp_min" : "Kasanna",
    ], "name": "Dallas",
       "id": "4684888",
       "coord": [
        "lat" : "32.78",
        "lon" : "-96.8",
    ], "weather": [
        [
            "description" : "drizzle",
            "icon" : "09d",
            "id" : "301",
            "main" : "Drizzle",
            ]
    ],
       "clouds":
        [
            "all" : "90",
    ],
       "dt": "1514327100",
       "base": "stations",
       "sys": [
        "country" : "US",
        "id" : "2592",
        "message" : "0.0061",
        "sunrise" : "1514294897",
        "sunset" : "1514330921",
        "type" : "1",
    ], "cod": "200", "visibility": "6437", "wind": [
        "deg" : "30",
        "speed" : "3.6",
    ]] as JSON ;
