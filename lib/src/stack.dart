/*
 *  Copyright 2020 chaobinwu89@gmail.com
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart' as widget;

/// The `Stack` widget has limited hit test when child is overflow with
/// `Positioned`. This behavior is intentional. For more detail refer to
/// the bug report: [Document that widgets in the overflow of stack do not
/// respond to gestures](https://github.com/flutter/flutter/issues/19445).
///
/// The optional way to enable the hit test is define a new Stack and remove
/// the size checking when teh Stack instance is overflow enable.
///
class Stack extends widget.Stack {
  /// Create stack instance
  Stack({
    widget.Key key,
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    TextDirection textDirection,
    StackFit fit = StackFit.loose,
    Overflow overflow = Overflow.clip,
    List<widget.Widget> children = const <widget.Widget>[],
  }) : super(
            key: key,
            alignment: alignment,
            textDirection: textDirection,
            fit: fit,
            overflow: overflow,
            children: children);

  @override
  RenderStack createRenderObject(widget.BuildContext context) {
    return _RenderStack(
      alignment: alignment,
      textDirection: textDirection ?? widget.Directionality.of(context),
      fit: fit,
      overflow: overflow,
    );
  }
}

/// Enable overflow hitTest
class _RenderStack extends RenderStack {
  _RenderStack({
    List<RenderBox> children,
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    TextDirection textDirection,
    StackFit fit = StackFit.loose,
    Overflow overflow = Overflow.clip,
  }) : super(
            children: children,
            alignment: alignment,
            textDirection: textDirection,
            fit: fit,
            overflow: overflow);

  @override
  bool hitTest(BoxHitTestResult result, {Offset position}) {
    if (overflow == Overflow.visible || size.contains(position)) {
      if (hitTestChildren(result, position: position) ||
          hitTestSelf(position)) {
        result.add(BoxHitTestEntry(this, position));
        return true;
      }
    }
    return false;
  }
}
