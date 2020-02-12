//
//  DAO Interface.swift
//  Tripper
//
//  Created by Denis Cherniy on 11.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation

protocol RoutePointDAO {
    func selectAll() -> [RoutePoint]
    func insert(_ point: RoutePoint)
    func update(_ point: RoutePoint)
    func delete(_ point: RoutePoint)
}
