//
//  ChipContainerView.swift
//  LinkPunch
//
//  Created by 나예슬 on 2023/08/23.
//

import SwiftUI

struct FieldChipContainerView: View {
    
    @StateObject var viewModel : ChipsViewModel
    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        return GeometryReader { geo in
            ZStack(alignment: .topLeading, content: {
                ForEach(viewModel.chipArray.indices, id:\.self) { index in
                    FieldChipView(fieldChipModel:$viewModel.chipArray[index])
                    .padding(.all,5)
                    .alignmentGuide(.leading) { dimension in
                        if (abs(width - dimension.width) > geo.size.width) {
                            width = 0
                            height -= dimension.height
                        }
                        let result = width
                        if viewModel.chipArray[index].id == viewModel.chipArray.last!.id {
                            width = 0
                        } else {
                            width -= dimension.width
                        }
                        return result
                    }
                    .alignmentGuide(.top) { dimension in
                        let result = height
                        if viewModel.chipArray[index].id == viewModel.chipArray.last!.id {
                            height = 0
                        }
                        return result
                    }
                }
            })
        }
    }
}

struct FieldChipContainerView_Previews: PreviewProvider {
    static var previews: some View {
        FieldChipContainerView(viewModel: ChipsViewModel())
    }
}
