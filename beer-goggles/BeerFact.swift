//
//  BeerFact.swift
//  beer-goggles
//
//  Created by Anton Lysov on 2018-04-04.
//  Copyright © 2018 Anton Lysov. All rights reserved.
//

import Foundation

struct BeerFact {
	private let facts = [
		"At any given time, 0.7% of the world is drunk. So 50 million people are drunk right now.",
		"Cenosillicaphobia is the fear of an empty beer glass.",
		"The world's longest hangover lasted 4 weeks after a Scotsman consumed 60 pints of beer.",
		"The strongest beer in the world has a 67.5% alcohol content.",
		"Slugs like beer.",
		"Amsterdam pays alcoholics in beer to clean streets: 5 cans of beer for a day's work, plus €10 and tobacco.",
		"Beer was not considered an alcoholic beverage in Russia until 2013.",
		"Until the 1970s in Belgium, table beer was served in schools refectories.",
		"At the Wife Carrying World Championships in Finland, first prize is the wife's weight in beer.",
		"There's a beer brewed from bananas in Africa.",
		"The Wat Pa Maha Chedi Kaew temple in Thailand was constructed with 1 million bottles of Heineken and a local beer.",
		"More Guinness beer is drunk in Nigeria than Ireland.",
		"In the Land of the Pharaohs of Egypt, beer was the national currency.",
		"In Argentina, political parties have their own brands of beer.",
		"Norway's first aircraft hijacking was resolved after the hijacker surrendered his weapon in exchange for more beer.",
		"When scientist Niels Bohr won the Nobel Prize in 1922, the Carlsberg brewery gave him a perpetual supply of beer piped into his house.",
		"In 1963, Albert Heineken created a beer bottle that could also be used as a brick to build sustainable housing in impoverished countries.",
		"As a rule of thumb, darker and bitter beers have higher alcohol content.",
		"In the 13th century, some people in Norway would baptize their children with beer.",
		"You can swim in pools of beer in Austria.",
		"62,719 pints of Guinness beer are wasted each year due to mustaches.",
		"President Jimmy Carter signed a bill that created an exemption from taxation of beer brewed at home for personal or family use, opening the door for today's craft beer brewers.",
		"In France, Germany, Austria, Spain and the Netherlands they serve beer in McDonald's.",
		"There's a brewery in Germany that's almost 1,000 years old. It has been in continuous operation since the year 1040.",
		"Beer was illegal in Iceland until March 1, 1989. Now, the date is celebrated every year in Reykjavik as Bjordagur, or Beer Day.",
		"Beer cans in Japan have braille on them so blind people don't confuse alcoholic drinks with soft drinks.",
		"Joan Evans is the only person on Earth capable of balancing 237 pints of beer atop his head.",
		"In 1956, the U.S. exploded atomic bombs near a few beers to see if they are safe to drink. They are indeed.",
		"Carlsberg Special Brew beer was created for Winston Churchill in 1950 on the behest of the Danish government.",
		"Table beer (1.5% alcohol) was served in Belgian schools until the 1980s."
	]
	
	var random: String {
		let factIndex = Int(arc4random_uniform(30))
		return facts[factIndex]
	}
}
