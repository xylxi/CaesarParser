//
//  JSONOperator.swift
//  JSONHelper
//
//  Created by Chenyu Lan on 5/15/15.
//  Copyright (c) 2015 Chenyu Lan. All rights reserved.
//

import Foundation

// MARK: - Protocol

/// Use for Class, Nested Type
public protocol Deserializable {
    init(json: JSONDictionary)
}

/// Use for Primitive Type
// @my: 转化，如果有值返回值，如果没有返回nil
public protocol Convertible {
    static func convert(json: JSONObject) -> Self?
}

// MARK: - Deserialization

struct Deserialization {

    // MARK: - Utils

    /// Convert object to nil if is Null
    private static func convertToNilIfNull(object: JSONObject?) -> JSONObject? {
        return object is NSNull ? nil : object
    }

    // MARK: - Convertible Type Deserialization
    /**
    为可选类型的成员变量赋值
    
    - parameter property:   成员变量
    - parameter jsonObject: value
    
    - returns: 如果有值赋值给成员，如果没有成员为nil
    T ：范型
    String?   T-->String
    Int?      T-->Int
    */
    static func convertAndAssign<T: Convertible>(inout property: T?, fromJSONObject jsonObject: JSONObject?) -> T? {
        if let data: JSONObject = convertToNilIfNull(jsonObject), convertedValue = T.convert(data) {
            property = convertedValue
        } else {
            property = nil
        }
        print("property->\(property)")
        return property
    }
    /**
     如果成员不是可选类型，则赋值走这个方法
     - parameter property:   成员
     - parameter jsonObject: 字典key的value
     - returns: 如果有value，赋值给成员，否则成员不变
     */
    static func convertAndAssign<T: Convertible>(inout property: T, fromJSONObject jsonObject: JSONObject?) -> T {
        var newValue: T?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
        if let newValue = newValue {
            property = newValue
        }
        print(property)
        return property
    }

    static func convertAndAssign<T: Convertible>(inout array: [T]?, fromJSONObject jsonObject: JSONObject?) -> [T]? {
        if let dataArray = convertToNilIfNull(jsonObject) as? [JSONObject] {
            array = [T]()
            for data in dataArray {
                if let property = T.convert(data) {
                    array!.append(property)
                }
            }
        } else {
            array = nil
        }
        return array
    }

    static func convertAndAssign<T: Convertible>(inout array: [T], fromJSONObject jsonObject: JSONObject?) -> [T] {
        var newValue: [T]?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
        if let newValue = newValue { array = newValue }
        return array
    }

    // MARK: - Custom Type Deserialization
    /**
    将字典的值赋值给对象的成员
    
    - parameter instance:   对象
    - parameter jsonObject: 字典
    
    - returns: 返回对象或者nil
    */
    static func convertAndAssign<T: Deserializable>(inout instance: T?, fromJSONObject jsonObject: JSONObject?) -> T? {
        print(instance)
        print(jsonObject)
        if let data = convertToNilIfNull(jsonObject) as? JSONDictionary {
            instance = T(json: data)
        } else {
            instance = nil
        }
        return instance
    }

    static func convertAndAssign<T: Deserializable>(inout instance: T, fromJSONObject jsonObject: JSONObject?) -> T {
        var newValue: T?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
        if let newValue = newValue { instance = newValue }
        return instance
    }

    static func convertAndAssign<T: Deserializable>(inout array: [T]?, fromJSONObject jsonObject: JSONObject?) -> [T]? {
        if let dataArray = convertToNilIfNull(jsonObject) as? [JSONDictionary] {
            array = [T]()
            for data in dataArray {
                array!.append(T(json: data))
            }
        } else {
            array = nil
        }
        return array
    }

    static func convertAndAssign<T: Deserializable>(inout array: [T], fromJSONObject jsonObject: JSONObject?) -> [T] {
        var newValue: [T]?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
        if let newArray = newValue { array = newArray }
        return array
    }

    // MARK: - Custom Value Converter

    static func convertAndAssign<T>(inout property: T?, fromJSONObject bundle:(jsonObject: JSONObject?, converter: (JSONObject) -> T?)) -> T? {
        if let data: JSONObject = convertToNilIfNull(bundle.jsonObject), convertedValue = bundle.converter(data) {
            property = convertedValue
        }
        return property
    }

    static func convertAndAssign<T>(inout property: T, fromJSONObject bundle:(jsonObject: JSONObject?, converter: (JSONObject) -> T?)) -> T {
        var newValue: T?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: bundle)
        if let newValue = newValue { property = newValue }
        return property
    }

    // MARK: - Custom Map Deserialiazation

    static func convertAndAssign<T, U where T: Convertible, U: Convertible, U: Hashable>(inout map: [U: T]?, fromJSONObject jsonObject: JSONObject?) -> [U: T]? {
        if let dataMap = convertToNilIfNull(jsonObject) as? JSONDictionary {
            map = [U: T]()
            for (key, data) in dataMap {
                if let convertedKey = U.convert(key), convertedValue = T.convert(data) {
                    map![convertedKey] = convertedValue
                }
            }
        } else {
            map = nil
        }
        return map
    }

    static func convertAndAssign<T, U where T: Convertible, U: Convertible, U: Hashable>(inout map: [U: T], fromJSONObject jsonObject: JSONObject?) -> [U: T] {
        var newValue: [U: T]?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
        if let newValue = newValue { map = newValue }
        return map
    }

    static func convertAndAssign<T, U where T: Deserializable, U: Convertible, U: Hashable>(inout map: [U: T]?, fromJSONObject jsonObject: JSONObject?) -> [U: T]? {
        if let dataMap = convertToNilIfNull(jsonObject) as? [String: JSONDictionary] {
            map = [U: T]()
            for (key, data) in dataMap {
                if let convertedKey = U.convert(key) {
                    map![convertedKey] = T(json: data)
                }
            }
        } else {
            map = nil
        }
        return map
    }

    static func convertAndAssign<T, U where T: Deserializable, U: Convertible, U: Hashable>(inout map: [U: T], fromJSONObject jsonObject: JSONObject?) -> [U: T] {
        var newValue: [U: T]?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
        if let newValue = newValue { map = newValue }
        return map
    }

    // MARK: - Raw Value Representable (Enum) Deserialization

    static func convertAndAssign<T: RawRepresentable where T.RawValue: Convertible>(inout property: T?, fromJSONObject jsonObject: JSONObject?) -> T? {
        var newEnumValue: T?
        var newRawEnumValue: T.RawValue?
        Deserialization.convertAndAssign(&newRawEnumValue, fromJSONObject: jsonObject)
        if let unwrappedNewRawEnumValue = newRawEnumValue {
            if let enumValue = T(rawValue: unwrappedNewRawEnumValue) {
                newEnumValue = enumValue
            }
        }
        property = newEnumValue
        return property
    }

    static func convertAndAssign<T: RawRepresentable where T.RawValue: Convertible>(inout property: T, fromJSONObject jsonObject: JSONObject?) -> T {
        var newValue: T?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
        if let newValue = newValue { property = newValue }
        return property
    }

    static func convertAndAssign<T: RawRepresentable where T.RawValue: Convertible>(inout array: [T]?, fromJSONObject jsonObject: JSONObject?) -> [T]? {
        if let dataArray = convertToNilIfNull(jsonObject) as? [JSONObject] {
            array = [T]()
            for data in dataArray {
                var newValue: T?
                Deserialization.convertAndAssign(&newValue, fromJSONObject: data)
                if let newValue = newValue { array!.append(newValue) }
            }
        } else {
            array = nil
        }
        return array
    }

    static func convertAndAssign<T: RawRepresentable where T.RawValue: Convertible>(inout array: [T], fromJSONObject jsonObject: JSONObject?) -> [T] {
        var newValue: [T]?
        Deserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
        if let newArray = newValue { array = newArray }
        return array
    }

}

// MARK: - Operator for use in deserialization operations.
// @my: 关于运算符的解析，包括结合性＋优先型 
//      http://nshipster.cn/swift-operators/
infix operator <-- { associativity right precedence 150 }

// MARK: - Convertible Type Deserialization
// @my: 遵守Convertible协议的走下面

public func <-- <T: Convertible>(inout property: T?, jsonObject: JSONObject?) -> T? {
    return Deserialization.convertAndAssign(&property, fromJSONObject: jsonObject)
}

public func <-- <T: Convertible>(inout property: T, jsonObject: JSONObject?) -> T {
    return Deserialization.convertAndAssign(&property, fromJSONObject: jsonObject)
}

public func <-- <T: Convertible>(inout array: [T]?, jsonObject: JSONObject?) -> [T]? {
    return Deserialization.convertAndAssign(&array, fromJSONObject: jsonObject)
}

public func <-- <T: Convertible>(inout array: [T], jsonObject: JSONObject?) -> [T] {
    return Deserialization.convertAndAssign(&array, fromJSONObject: jsonObject)
}

// MARK: - Custom Type Deserialization
// @my: 遵守Deserializable协议的走下面
public func <-- <T: Deserializable>(inout instance: T?, jsonObject: JSONObject?) -> T? {
    return Deserialization.convertAndAssign(&instance, fromJSONObject: jsonObject)
}

public func <-- <T: Deserializable>(inout instance: T, jsonObject: JSONObject?) -> T {
    return Deserialization.convertAndAssign(&instance, fromJSONObject: jsonObject)
}

public func <-- <T: Deserializable>(inout array: [T]?, jsonObject: JSONObject?) -> [T]? {
    return Deserialization.convertAndAssign(&array, fromJSONObject: jsonObject)
}

public func <-- <T: Deserializable>(inout array: [T], jsonObject: JSONObject?) -> [T] {
    return Deserialization.convertAndAssign(&array, fromJSONObject: jsonObject)
}

// MARK: - Custom Value Converter

public func <-- <T>(inout property: T?, bundle:(jsonObject: JSONObject?, converter: (JSONObject) -> T?)) -> T? {
    return Deserialization.convertAndAssign(&property, fromJSONObject: bundle)
}

public func <-- <T>(inout property: T, bundle:(jsonObject: JSONObject?, converter: (JSONObject) -> T?)) -> T {
    return Deserialization.convertAndAssign(&property, fromJSONObject: bundle)
}

// MARK: - Custom Map Deserialiazation

public func <-- <T, U where T: Convertible, U: Convertible, U: Hashable>(inout map: [U: T]?, jsonObject: JSONObject?) -> [U: T]? {
    return Deserialization.convertAndAssign(&map, fromJSONObject: jsonObject)
}

public func <-- <T, U where T: Convertible, U: Convertible, U: Hashable>(inout map: [U: T], jsonObject: JSONObject?) -> [U: T] {
    return Deserialization.convertAndAssign(&map, fromJSONObject: jsonObject)
}

public func <-- <T, U where T: Deserializable, U: Convertible, U: Hashable>(inout map: [U: T]?, jsonObject: JSONObject?) -> [U: T]? {
    return Deserialization.convertAndAssign(&map, fromJSONObject: jsonObject)
}

public func <-- <T, U where T: Deserializable, U: Convertible, U: Hashable>(inout map: [U: T], jsonObject: JSONObject?) -> [U: T] {
    return Deserialization.convertAndAssign(&map, fromJSONObject: jsonObject)
}

// MARK: - Raw Value Representable (Enum) Deserialization

public func <-- <T: RawRepresentable where T.RawValue: Convertible>(inout property: T?, jsonObject: JSONObject?) -> T? {
    return Deserialization.convertAndAssign(&property, fromJSONObject: jsonObject)
}

public func <-- <T: RawRepresentable where T.RawValue: Convertible>(inout property: T, jsonObject: JSONObject?) -> T {
    return Deserialization.convertAndAssign(&property, fromJSONObject: jsonObject)
}

public func <-- <T: RawRepresentable where T.RawValue: Convertible>(inout array: [T]?, jsonObject: JSONObject?) -> [T]? {
    return Deserialization.convertAndAssign(&array, fromJSONObject: jsonObject)
}

public func <-- <T: RawRepresentable where T.RawValue: Convertible>(inout array: [T], jsonObject: JSONObject?) -> [T] {
    return Deserialization.convertAndAssign(&array, fromJSONObject: jsonObject)
}
