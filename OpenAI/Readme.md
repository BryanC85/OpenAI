#OpenAI ChatGPT Swift Framework

This is a Swift framework that provides a client interface for the OpenAI API, specifically for the GPT model. The framework includes classes for configuring the API, generating text completions, and searching the OpenAI knowledge base.

Getting Started

To use the framework, you will need to sign up for an OpenAI API key and include it in your project. You can sign up for an API key here.

Prerequisites
Xcode 12 or later
Swift 5.3 or later
An OpenAI API key
Installing
To install the framework in your project, you can add it to your project using Swift Package Manager.

In Xcode, select File > Swift Packages > Add Package Dependency...
Enter the URL for the OpenAI framework repository: https://github.com/openai/swift
Choose the latest release version and click "Next".
Select your project target and click "Finish".
The framework will now be added to your project and can be imported in your Swift code:
import OpenAI

Configuration
Before you can use the OpenAI API, you will need to configure the framework with your API key. You can do this by creating an instance of the OpenAIConfig class and setting the apiKey property:

let config = OpenAIConfig.sharedInstance()
config.apiKey = "YOUR_API_KEY_HERE"

Generating Text Completions
To generate text completions using the GPT model, you can use the generateCompletions method on the OpenAI class:

let openAI = OpenAI.sharedInstance()
openAI.generateCompletions(forPrompt: "Hello, my name is", maxTokens: 5) { completions, error in
    if let error = error {
        print("Error: \(error.localizedDescription)")
    } else if let completions = completions {
        print("Completions: \(completions)")
    }
}

This code generates text completions for the prompt "Hello, my name is" with a maximum of 5 tokens. The completions are returned in the completions parameter of the completion handler as an array of OpenAICompletion objects.

Searching the Knowledge Base
To search the OpenAI knowledge base, you can use the search method on the OpenAI class:

let openAI = OpenAI.sharedInstance()
openAI.search(documents: ["What is OpenAI?"]) { results, error in
    if let error = error {
        print("Error: \(error.localizedDescription)")
    } else if let results = results {
        print("Results: \(results)")
    }
}

This code searches the OpenAI knowledge base for the query "What is OpenAI?" and returns the results in the results parameter of the completion handler as an array of OpenAIAnswer objects.

Advanced Configuration
The OpenAIConfig class provides additional configuration options for the OpenAI API, including the base URL, API version, and HTTP headers. You can modify these options using the baseUrl, apiVersion, and httpHeaders properties, respectively:

let config = OpenAIConfig.sharedInstance()
config.apiKey = "YOUR_API_KEY_HERE"
config.baseUrl = "https://api.openai.com"
config.apiVersion = "v1"
config.httpHeaders = [
    "Content-Type": "application/json",
    "User-Agent": "MyApp/1.0"]


