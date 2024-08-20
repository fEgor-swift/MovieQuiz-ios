//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Admin on 19.08.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {               
    func didReceiveNextQuestion(question: QuizQuestion?)
}
