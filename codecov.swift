#!/usr/bin/swift
/**
 * This Script is retreiving the code converage percentage from slather cobertura.xml
 * Applies a regex on the file to retrieve the percentage
 * Send the formatted percentage to circle-ci
 *
 *
 *
 */

import Foundation

class CodeCoverage {

    var coverageFormatted: String = ""

    func main() {
        let content: String = readFileContent()
        let coverage = parseCoverage(fromString: content)
        coverageFormatted = String(format: "%.2f", coverage)
        print("Coverage Percentage : \(coverageFormatted)%")

        let urlString = makeStatusUri()
        send(url: urlString) { res in
            print(res)
        }
    }

    func readFileContent() -> String {
        let file = "/xml_report/cobertura.xml"
        let dir = FileManager.default.currentDirectoryPath
        let path = dir.appending(file)

        return try! String(contentsOfFile: path)
    }

    func parseCoverage(fromString content: String) -> Float {
        let regxString = "coverage line-rate=\"(\\d.\\d+)\"\\s+branch-rate"
        let regex = try! NSRegularExpression(pattern: regxString, options: [])

        let results = regex.matches(in: content,
                                    options: [],
                                    range: NSRange(location: 0, length: content.characters.count)
        )

        let coveragePercentage = (content as NSString).substring(with: results.first!.rangeAt(1))
        return Float(coveragePercentage)! * 100.0
    }

    // Environment Variables
    func getEnvironmentVar(_ name: String) -> String? {
        guard let rawValue = getenv(name) else { return nil }
        return String(utf8String: rawValue)
    }

    // Make github uri
    func makeStatusUri() -> String {
        let circleUserName = getEnvironmentVar("CIRCLE_PROJECT_USERNAME")!
        let circleRepoName = getEnvironmentVar("CIRCLE_PROJECT_REPONAME")!
        let circleSha1 = getEnvironmentVar("CIRCLE_SHA1")!
        let gitHubToken = getEnvironmentVar("GITHUB_STATUS_TOKEN")!

        return "https://api.github.com/repos/\(circleUserName)/\(circleRepoName)/statuses/\(circleSha1)?access_token=\(gitHubToken)"
    }

    func makeCoverageUrl() -> String {
        let circleUserName = getEnvironmentVar("CIRCLE_PROJECT_USERNAME")!
        let circleRepoName = getEnvironmentVar("CIRCLE_PROJECT_REPONAME")!
        let circleBuildNum = getEnvironmentVar("CIRCLE_BUILD_NUM")!
        let circleArtifacts = getEnvironmentVar("CIRCLE_ARTIFACTS")!

        return "https://circleci.com/api/v1.1/project/github/\(circleUserName)/\(circleRepoName)/\(circleBuildNum)/artifacts/0/\(circleArtifacts)/coverage/index.html"
    }

    // Networking method
    func send(url: String, result: (String) -> Void) {
        let url = URL(string: url)!

        let json = [ "state": "success",
            "target_url": makeCoverageUrl(),
            "description": "Coverage at \(coverageFormatted)%",
            "context": "ci/coverage"]

        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("request", forHTTPHeaderField: "User-Agent")

        let semaphore = DispatchSemaphore(value: 0)

        var data: Data? = nil

        URLSession.shared.dataTask(with: request) { (responseData, _, error) -> Void in
            assert(error == nil, String(describing: error))
            data = responseData
            semaphore.signal()
        }.resume()

        _ = semaphore.wait(timeout: .distantFuture)

        let reply = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
        result(reply)
    }
}

CodeCoverage().main()
