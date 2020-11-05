//
//  ServiceLocator.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/1/20.
//

import Swinject

protocol ServiceLocator {
  func resolve<Service>(_ serviceType: Service.Type) -> Service
  func resolve<Service, Arg>(_ serviceType: Service.Type, argument: Arg) -> Service
}
