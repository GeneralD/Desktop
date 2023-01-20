//
//  Spell.swift
//
//  Created by Yumenosuke Koukata on 2023/01/05.
//

struct Spell: Equatable, Hashable {
	let phrase: String
	let enhanced: Int
}

extension Spell: Identifiable {
	var id: Int { hashValue }
}

extension Spell {
	static func from(_ str: String) -> Self {
		func reduce(_ base: Self) -> Self {
			// peel off braces
			if let match = try? inBracesRegex.wholeMatch(in: base.phrase)?.output.match.description {
				return reduce(.init(phrase: match, enhanced: base.enhanced + 1))
			}
			// peel off brackets
			if let match = try? inBracketsRegex.wholeMatch(in: base.phrase)?.output.match.description {
				return reduce(.init(phrase: match, enhanced: base.enhanced - 1))
			}
			// peel off parentheses
			if let match = try? inParenthesesRegex.wholeMatch(in: base.phrase)?.output.match.description {
				return reduce(.init(phrase: match, enhanced: base.enhanced + 1))
			}
			// clean parentheses of one half
			if let match = try? cleanerRegex.wholeMatch(in: base.phrase)?.output.match.description {
				return .init(phrase: match, enhanced: base.enhanced)
			}
			return base
		}

		return reduce(.init(phrase: str, enhanced: .zero))
	}
}

private extension Spell {
	static let inBracesRegex = #/^\{(?<match>.+)\}$/#
	static let inBracketsRegex = #/^\[(?<match>.+)\]$/#
	static let inParenthesesRegex = #/^\((?<match>.+)\)$/#
	static let cleanerRegex = #/^[\{\[\(]*(?<match>.+?)[\}\]\)]*$/#
}
