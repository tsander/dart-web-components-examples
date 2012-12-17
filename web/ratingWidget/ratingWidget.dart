import 'package:web_ui/web_ui.dart';
  
class RatingWidget extends WebComponent {
  num min = 0;
  num max = 5;
  num step = 0.5;
  bool readonly = false;
  bool resetable = true;
  int starwidth = 16;
  int starheight = 16;
  num value = 0;
  bool ispreset = true;
  num hoverWidth = 0;
  
  int get rangeWidth => (starwidth * (max - min)).toInt();
  
  int get rangeHeight => starheight;
  
  int get selectedWidth => (starwidth * (value - min)).toInt();
  
  Map<String, String> get rangeStyle => {
    "width" : "${rangeWidth}px",
    "height" : "${rangeHeight}px",
  };
  
  Map<String, String> get selectedStyle => {
    "width" : "${selectedWidth}px",
    "height" : "${rangeHeight}px",
  };
  
  Map<String, String> get hoverStyle => {
    "width" : "${hoverWidth}px",
    "height" : "${rangeHeight}px",
  };
  
  Map<String, String> get resetStyle => {
    "display" : (!resetable || readonly) ? "none" : ""
  };
  
  String get presetClass => ispreset ? "rateit-preset" : "";
  
  int get starsWidth => (value - min) * starwidth;
  
  void reset(event) {
    value = min;
    hoverWidth = 0;
    // Set backing store??
    // Trigger reset??
  }
  
  int calcRawScore(event) {
    return (event.offsetX / starwidth * (1 / step)).ceil().toInt();
  }
  
  void mousemove(event) {
    if (readonly) {
      return;
    }
    int score = calcRawScore(event);
    hoverWidth = score * starwidth * step;
  }
  
  void mouseout(event) {
    hoverWidth = 0;
  }
  
  void mouseup(event) {
    if (readonly) {
      return;
    }
    int score = calcRawScore(event);
    value = ((score * step) + min);
    ispreset = false;
  }
}
