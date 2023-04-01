//
//  ToDoFileManager.swift
//  PersistentToDoList
//
//  Created by Djinsolobzik on 31.03.2023.
//

import Foundation
final class ToDoFileManager {
    func writeDataArray<T: Encodable>(dataArray: T) {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathExtension("toDoList.plist") else { return }
        let encoder = PropertyListEncoder()

        do {
            let data = try encoder.encode(dataArray)
            try data.write(to: path)
        } catch (let error){
            print(error)
        }
    }

    func readDataArray<T: Decodable>() -> [T] {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathExtension("toDoList.plist") else { return []}
        let decoder = PropertyListDecoder()

        do {
            let data = try Data(contentsOf: path)
            let decodeData = try decoder.decode([T].self, from: data)
            return decodeData
        } catch (let error) {
            print(error)
        }
        return []
    }
}
