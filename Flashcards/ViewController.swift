//
//  ViewController.swift
//  Flashcards
//
//  Created by Osoname Omonagbe on 2/26/22.
//

import UIKit

struct Flashcard{
    var question: String
    var answer: String
}

class ViewController: UIViewController {

    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var Backlabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    
   
    
    //Array to hold our Flashcard
    var flashcards = [Flashcard]()
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        
        //read saved flashcards
        readSavedFlashcards()
        
        //adding our initial flashcards if needed
        if flashcards.count == 0{
        updateFlashcard(question: "what's the capital of Brazil?", answer: "Brasilia")
        } else {
            updateLabels()
            updateNextPrevButtons()
        }
        
    }
    

    
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        frontLabel.isHidden = !frontLabel.isHidden
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        currentIndex = currentIndex - 1
        
        //update labels
        updateLabels()
        //update buttons
        updateNextPrevButtons()
        bringFrontBack()
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        // Increase current index
        currentIndex = currentIndex + 1
        
        //update labels
        updateLabels()
        //update buttons
        updateNextPrevButtons()
        bringFrontBack()
    }
    
    func updateFlashcard(question: String,  answer: String) {
        // Do stuff here
        let flashcard = Flashcard(question: question, answer: answer)
        frontLabel.text = flashcard.question
        Backlabel.text = flashcard.answer
        
        flashcards.append(flashcard)
        
        print("Added new flashcard")
        print("we now have \(flashcards.count) flashcards")
        // update current Index
        currentIndex = flashcards.count - 1
        print("Our current index is \(currentIndex)")
        
        updateNextPrevButtons()
        updateLabels()
        saveAllFlashcardsToDisk()
        bringFrontBack()
        
    }
    
    func bringFrontBack(){
        //bring the front label back.
        frontLabel.isHidden = false
    }
    
    func updateLabels(){
        let currentFlashcard = flashcards[currentIndex]
        frontLabel.text = currentFlashcard.question
        Backlabel.text = currentFlashcard.answer
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController = segue.destination as! UINavigationController
        
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashcardsController = self
        
    }
    

    func updateNextPrevButtons(){
        
        //Disable next button if at the end
        if currentIndex == flashcards.count - 1{
            nextButton.isEnabled = false
        }else {
            nextButton.isEnabled = true
        }
        
        }
    
    func saveAllFlashcardsToDisk(){
        
        // From flashcard array to dictionary array
        let dictionaryArray = flashcards.map { (card)  -> [String:String] in
            return ["question": card.question, "answer": card.answer] }
        
        // Save array on disk using userDefaults
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
    print(" Flashcards saved to UserDefaults")
            
       //save array on disk using UserDefaults
    //UserDefaults.standard.set(flashcards, forKey: "flashcards")
        
        
        
        }
    func readSavedFlashcards(){
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String:String]]{
            // in here we know for sure we have a dictionary array
    let savedCards = dictionaryArray.map { dictionary -> Flashcard  in
                return Flashcard (question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            
            //put all these cards in our flashcards array
            flashcards.append(contentsOf: savedCards)
        }
    }
}




