//
//  WorldCup.swift
//  CampeoesDasCopas
//
//  Created by Douglas Frari on 24/05/18.
//  Copyright © 2018 CESAR School. All rights reserved.
//

import Foundation

struct WorldCup: Codable {
    
    let year: Int
    let country: String
    let winner: String
    let vice: String
    let winnerScore: String
    let viceScore: String
    let matches: [Match]
}

struct Match: Codable {
    let stage: String
    let games: [Game]
}

struct Game: Codable {
    let home: String
    let away: String
    let score: String
    let date: String
}
