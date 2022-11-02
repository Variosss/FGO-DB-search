//
//  SearchResult.swift
//  FGO DB search
//
//  Created by Jakub Grąbka on 01/11/2022.
//

import SwiftUI

struct SearchResult: View {
    

    var body: some View {
        testfunc()
    }
}
func testfunc() -> Text
{
    @ObservedObject var global = Params.global
    return Text(global.nazwa)
}
