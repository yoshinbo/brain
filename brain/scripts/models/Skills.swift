//
//  Skills.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/12/03.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//


import Foundation

class Skill {

    var id: Int
    var name: String
    var cost: Int
    var type: Int
    var value: Int
    var desc: String
    var requiredBrainId: Int


    init(id: Int, name: String, cost: Int, type: Int, value: Int, desc: String, requiredBrainId: Int) {
        self.id = id
        self.name = name
        self.cost = cost
        self.type = type
        self.value = value
        self.desc = desc
        self.requiredBrainId = requiredBrainId
    }
}

class Skills: NSObject {

    var skills:[Skill] = []

    override init() {
        super.init()
        for skillKind in skillKinds {
            var skill = Skill(
                id: skillKind.id,
                name: skillKind.name,
                cost: skillKind.cost,
                type: skillKind.type,
                value: skillKind.value,
                desc: skillKind.desc,
                requiredBrainId: skillKind.requiredBrainId
            )
            self.skills.append([skill][0])
        }
    }

    func getByIndex(indexId: Int) -> Skill {
        return self.skills[indexId]
    }

    func getById(id: Int) -> Skill? {
        for skill in self.skills {
            if skill.id == id {
                return skill
            }
        }
        return nil
    }
}
