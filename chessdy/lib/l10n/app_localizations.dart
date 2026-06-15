import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('mn'),
  ];

  // Navigation
  String get home => locale.languageCode == 'mn' ? 'Нүүр' : 'Home';
  String get play => locale.languageCode == 'mn' ? 'Тоглох' : 'Play';
  String get train => locale.languageCode == 'mn' ? 'Бэлтгэл' : 'Train';
  String get lesson => locale.languageCode == 'mn' ? 'Хичээл' : 'Lesson';

  // Home Page
  String get appTitle => locale.languageCode == 'mn' ? 'Chessdy' : 'Chessdy';
  String get masterChessToday => locale.languageCode == 'mn' ? 'Шатар Сурах Апп' : 'Master Chess Today';
  String get learnTrainPlay => locale.languageCode == 'mn' ? 'Сурах, Бэлтгэл Хийх, Тоглох' : 'Learn, Train, and Play';
  String get aiCoachLabel => locale.languageCode == 'mn' ? 'ДАСГАЛЖУУЛАГЧ' : 'COACH';
  String get readyToTrain => locale.languageCode == 'mn' ? 'Бэлтгэлд бэлэн' : 'Ready to train';
  String get quickAccess => locale.languageCode == 'mn' ? 'Хурдан хандах' : 'Quick Access';
  String get featureAiAnalysis => locale.languageCode == 'mn' ? 'Шинжилгээ' : 'Analysis';
  String get featurePlayVsHuman => locale.languageCode == 'mn' ? 'Хүнтэй тоглох' : 'Play vs Human';
  String get featureLessons => locale.languageCode == 'mn' ? 'Хичээлүүд' : 'Lessons';
  String get featureLang => locale.languageCode == 'mn' ? 'МН / ENG' : 'ENG / MN';
  String get subtitleStats => locale.languageCode == 'mn' ? 'Явц ба тэмдэгтүүдийг хянах' : 'Track your progress & badges';
  String get subtitleSettings => locale.languageCode == 'mn' ? 'Загвар, хэл & тохиргоо' : 'Theme, language & preferences';
  String get subtitleFeedback => locale.languageCode == 'mn' ? 'Санал илгээх эсвэл тусламж авах' : 'Send feedback or get help';
  String get subtitleAbout => locale.languageCode == 'mn' ? '1.0.0 хувилбар · © 2026 Chessdy' : 'Version 1.0.0 · © 2026 Chessdy';

  // Settings
  String get settings => locale.languageCode == 'mn' ? 'Тохиргоо' : 'Settings';
  String get sound => locale.languageCode == 'mn' ? 'Дуу' : 'Sound';
  String get volume => locale.languageCode == 'mn' ? 'Дууны түвшин' : 'Volume';
  String get notifications => locale.languageCode == 'mn' ? 'Мэдэгдэл' : 'Notifications';
  String get darkMode => locale.languageCode == 'mn' ? 'Бүдэг горим' : 'Dark Mode';
  String get darkThemeEnabled => locale.languageCode == 'mn' ? 'Бүдэг горим идэвхтэй' : 'Dark theme enabled';
  String get lightThemeEnabled => locale.languageCode == 'mn' ? 'Гэрэлтэй горим идэвхтэй' : 'Light theme enabled';
  String get language => locale.languageCode == 'mn' ? 'Хэл' : 'Language';
  String get mongolian => locale.languageCode == 'mn' ? 'Монгол' : 'Mongolian';
  String get english => locale.languageCode == 'mn' ? 'Англи' : 'English';
  String get languageEnabled => locale.languageCode == 'mn' 
      ? (locale.languageCode == 'mn' ? 'Монгол хэл сонгогдсон' : 'Англи хэл сонгогдсон')
      : (locale.languageCode == 'mn' ? 'Mongolian selected' : 'English selected');

  // Statistics & Achievements
  String get statisticsAndAchievements => locale.languageCode == 'mn' 
      ? 'Статистик ба Амжилтууд' 
      : 'Statistics & Achievements';
  String get achievements => locale.languageCode == 'mn' ? 'Амжилтууд' : 'Achievements';
  String get aiBeater => locale.languageCode == 'mn' ? 'AI-г Ялагч' : 'AI Beater';
  String get winAgainstAI => locale.languageCode == 'mn' ? 'AI-н эсрэг тоглолт хожих' : 'Win a game against the AI';
  String get totalWins => locale.languageCode == 'mn' ? 'Нийт хожсон' : 'Total Wins';
  String get lessonsProgress => locale.languageCode == 'mn' ? 'Хичээлийн Явц' : 'Lessons Progress';
  String get completed => locale.languageCode == 'mn' ? 'Дууссан' : 'Completed';
  String get progress => locale.languageCode == 'mn' ? 'Явц' : 'Progress';
  String get lessonsCompleted => locale.languageCode == 'mn' ? 'Хичээл дууссан' : 'lessons completed';

  // Feedback & Support
  String get feedbackAndSupport => locale.languageCode == 'mn' ? 'Санал ба Дэмжлэг' : 'Feedback & Support';

  // Lessons
  String get lessons => locale.languageCode == 'mn' ? 'Хичээлүүд' : 'Lessons';
  String get basicRules => locale.languageCode == 'mn' ? 'Үндсэн Дүрэм' : 'Basic Rules';
  String get specialMoves => locale.languageCode == 'mn' ? 'Тусгай Нүүдлүүд' : 'Special Moves';
  String get matingPatterns => locale.languageCode == 'mn' ? 'Мадлах Аргууд' : 'Checkmates';
  String get advancedTactics => locale.languageCode == 'mn' ? 'Ахисан Тактик' : 'Advanced Tactics';
  
  // Game/Train
  String get newGame => locale.languageCode == 'mn' ? 'Шинэ Тоглолт' : 'New Game';
  String get undo => locale.languageCode == 'mn' ? 'Буцаах' : 'Undo';
  String get playVsAI => locale.languageCode == 'mn' ? 'AI-ын эсрэг тоглох ' : 'Play vs AI';
  String get playVsAIDescription => locale.languageCode == 'mn' 
      ? '• Хөлөг дээр нүүдлээ хий\n• AI автоматаар хариулах болно' 
      : '• Make your move on the board\n• AI will respond automatically';
  String get makeYourMove => locale.languageCode == 'mn' ? 'Нүүдлээ хий!' : 'Make your move!';
  String get aiThinking => locale.languageCode == 'mn' ? 'AI бодож байна...' : 'AI is thinking...';
  String get gameOver => locale.languageCode == 'mn' ? 'Тоглолт дууслаа!' : 'Game Over!';
  String get playAs => locale.languageCode == 'mn' ? 'Тоглох:' : 'Play as:';
  String get white => locale.languageCode == 'mn' ? 'Цагаан' : 'White';
  String get black => locale.languageCode == 'mn' ? 'Хар' : 'Black';
  String get aiPlayed => locale.languageCode == 'mn' ? 'AI нүүсэн:' : 'AI played';
  String get backendError => locale.languageCode == 'mn' ? 'Алдаа?' : 'Error!';
  // Commentary
  String get coachOnYourMove => locale.languageCode == 'mn' ? 'AI таны нүүдлийн талаар:' : 'AI on your move:';
  String get coachOnAIMove => locale.languageCode == 'mn' ? 'AI өөрийн нүүдлийн талаар:' : 'AI on her move:';
  String get coachIsWatching => locale.languageCode == 'mn' ? 'Дасгалжуулагч ажиглаж байна...' : 'Coach is watching...';

  // Dialogs
  String get congratulations => locale.languageCode == 'mn' ? 'Баяр хүргэе!' : 'Congratulations!';
  String get youBeatAI => locale.languageCode == 'mn' ? 'Та AI-г яллаа!' : 'You beat the AI!';
  String get awesome => locale.languageCode == 'mn' ? 'Гайхалтай!' : 'Awesome!';
  String get youWon => locale.languageCode == 'mn' ? 'Та хожлоо!' : 'You Won!';
  String get aiWon => locale.languageCode == 'mn' ? 'Тоглоом дууслаа. AI хожлоо!' : 'Game Over. AI Won!';
  String get draw => locale.languageCode == 'mn' ? 'Тоглоом дууслаа. Тэнцлээ!' : 'Game Over. Draw!';

  // Lesson names
  String get aboutThePieces => locale.languageCode == 'mn' ? 'Шатрын тухай' : 'About the Pieces';
  String get howToCapture => locale.languageCode == 'mn' ? 'Хэрхэн идэх вэ' : 'How to Capture';
  String get worthOfPieces => locale.languageCode == 'mn' ? 'Шатрын үнэ цэнэ' : 'Worth of the Pieces';
  String get howToCastle => locale.languageCode == 'mn' ? 'Хэрхэн сэлгээ хийх вэ' : 'How to Castle';
  String get aboutCheckAndCheckmate => locale.languageCode == 'mn' ? 'Шаг ба Шагмад' : 'About Check and Checkmate';
  String get aboutEnPassant => locale.languageCode == 'mn' ? 'Эн Пассан гэж юу вэ?' : 'About En Passant';
  
  // Lesson descriptions
  String get aboutThePiecesDescription => locale.languageCode == 'mn' 
      ? 'Шатрын хөлөг тус бүрийн хэрхэн хөдөлдөгийг суралц.' 
      : 'Learn about each chess piece and how they move.';
  String get howToCaptureDescription => locale.languageCode == 'mn' 
      ? 'Хөлгөөр хэрхэн идэхийг сураарай.' 
      : 'Understand how pieces capture each other.';
  String get worthOfPiecesDescription => locale.languageCode == 'mn' 
      ? 'Хөлөг бүрийн харьцангуй үнэ цэнийг суралцаарай.' 
      : 'Learn the relative value of each piece.';
  String get howToCastleDescription => locale.languageCode == 'mn' 
      ? 'Сэлгэх өвөрмөц хөдөлгөөнийг сураарай.' 
      : 'Master the special castling move.';
  String get aboutCheckAndCheckmateDescription => locale.languageCode == 'mn' 
      ? 'Шаг, шагмад болон хэрхэн ялахыг ойлгоорой.' 
      : 'Understand check, checkmate, and how to win.';
  String get aboutEnPassantDescription => locale.languageCode == 'mn' 
      ? 'Эн Пассан идэх онцгой дүрмийг сураарай.' 
      : 'Learn the special en passant capture rule.';
  
  // Common buttons
  String get cancel => locale.languageCode == 'mn' ? 'Цуцлах' : 'Cancel';
  String get ok => locale.languageCode == 'mn' ? 'За' : 'OK';
  String get close => locale.languageCode == 'mn' ? 'Хаах' : 'Close';
  String get next => locale.languageCode == 'mn' ? 'Дараах' : 'Next';
  String get back => locale.languageCode == 'mn' ? 'Буцах' : 'Back';
  String get start => locale.languageCode == 'mn' ? 'Эхлэх' : 'Start';
  String get nextStep => locale.languageCode == 'mn' ? 'Дараагийн алхам' : 'Next Step';
  String get finishLesson => locale.languageCode == 'mn' ? 'Хичээлийг дуусгах' : 'Finish Lesson';
  String get completeLesson => locale.languageCode == 'mn' ? 'Хичээлийг дуусгах' : 'Complete Lesson';
  String get lessonCompleted => locale.languageCode == 'mn' ? 'Хичээл дууслаа!' : 'Lesson completed!';
  String get correct => locale.languageCode == 'mn' ? 'Зөв!' : 'Correct!';
  String get tryAgain => locale.languageCode == 'mn' ? 'Дахин оролдоно уу' : 'Try again';

  // Dr. Wolf Style General Coach Strings
  String get hintButton => locale.languageCode == 'mn' ? 'Тусламж авах' : 'Show Hint';
  String get coachAlmostRight => locale.languageCode == 'mn' ? 'Биш ээ, гэхдээ үргэлжлүүлэн бодоорой: ' : 'Not quite right, but think about this: ';
  String get coachTryAgain => locale.languageCode == 'mn' ? 'Өөр нүүдэл хийгээд үзье!' : 'Let\'s try another move!';
  String get coachSays => locale.languageCode == 'mn' ? 'Багш:' : 'Coach:';
  String get letsReview => locale.languageCode == 'mn' ? 'Товч дүгнэлт' : 'Summary';

  // Specific Dr. Wolf feedback for "About the Pieces"
  String get coachPiecesMastery => locale.languageCode == 'mn' ? 'Сайн байна! Одоо та хөлөг дээрх бүх дүрс хэрхэн нүүдгийг мэддэг боллоо. Дараагийн хичээлүүдэд хэрхэн идэх тухай үзэх болно. Амжилт!' : 'Excellent! You now know how every piece moves. In the next lessons, we will explore how they capture. Good luck!';
  String get coachPawnHint => locale.languageCode == 'mn' ? 'Хүү зөвхөн урагшаа чигээрээ 1 эсвэл 2 нүд нүддэг. Та хүүгээ 1 нүд урагшлуул уу.' : 'Pawns march straight forward. Move your pawn forward one square.';
  String get coachPawnSuccess => locale.languageCode == 'mn' ? 'Яг зөв! Хүүзөвхөн урагшаа нүүнэ.' : 'Spot on! Pawns march forward bravely.';
  String get coachRookHint => locale.languageCode == 'mn' ? 'Тэрэг босоо болон хэвтээ чиглэлд хүссэн хэмжээгээрээ нүднэ. Тэргийг төв рүү e5 руу нүү.' : 'Rooks glide horizontally and vertically. Move it to the center at e5.';
  String get coachRookWrongA4 => locale.languageCode == 'mn' ? 'Энэ бол босоо нүүдэл биш байна. Тэрэг зөвхөн шулуун замаар явах ёстой. a4 онцгүй байна.' : 'That\'s not quite it. Rooks move in straight lines. Moving to a4 won\'t help us here.';
  String get coachRookSuccess => locale.languageCode == 'mn' ? 'Сайн байна, тэрэг маш хүчирхэг.' : 'Nicely done. Rooks control open files beautifully.';
  String get coachKnightHint => locale.languageCode == 'mn' ? 'Морь L үсэг хэлбэрээр үсэрч нүүнэ. Бусад дүрсийг дээгүүр нь давна.' : 'Knights hop in an L-shape. Jump over into c5.';
  String get coachKnightSuccess => locale.languageCode == 'mn' ? 'Төгс!' : 'Perfect jump!';
  String get coachBishopHint => locale.languageCode == 'mn' ? 'Тэмээ зөвхөн диагональ замаар явна.' : 'Bishops stay on their color and slide diagonally. Slide up to d5.';
  String get coachBishopSuccess => locale.languageCode == 'mn' ? 'Зөв! Тэмээ алсын зайных.' : 'Correct! Bishops are long-range snipers.';
  String get coachQueenHint => locale.languageCode == 'mn' ? 'Бэрс тэрэг болон тэмээ 2-ийн хөдөлгөөнийг нийлүүлсэн мэт нүүдэг.' : 'The Queen combines Rook and Bishop. She goes anywhere. Move to e5.';
  String get coachQueenSuccess => locale.languageCode == 'mn' ? 'Хүчирхэг нүүдэл.' : 'A powerful move for the most powerful piece.';
  String get coachKingHint => locale.languageCode == 'mn' ? 'Хаан аль ч чиглэлд 1 нүд нүүнэ.' : 'The King takes exactly one slow step in any direction.';
  String get coachKingSuccess => locale.languageCode == 'mn' ? 'Хаанаар зөв нүүлээ!' : 'Well handled. Protect him at all costs!';

  // Specific Dr. Wolf feedback for "How to Capture"
  String get coachCaptureMastery => locale.languageCode == 'mn' ? 'Маш сайн. Та хэрхэн идэхийг сурлаа! Хөлөг идэгдэх үед шууд тоглоомноос гардаг.' : 'Great job! You learned how capturing works. When a piece is captured, it leaves the board completely.';
  String get coachCaptureHintText => locale.languageCode == 'mn' ? 'Идэх дүрсээ сонгоод өрсөлдөгчийнхөө дүрс дээр аваачиж тавина.' : 'Take your piece and replace the opponent’s piece on its square.';
  String get coachGreatCapture => locale.languageCode == 'mn' ? 'Сайн идлээ!' : 'A delicious capture!';
  String get coachWrongCaptureQueen => locale.languageCode == 'mn' ? 'Бэрсээрээ хаашаа ч нүүж болох ч яг одоо өрсөлдөгчийн бэрсийг идэх хэрэгтэй.' : 'You can move the Queen there, but right now we are practicing capturing the enemy Queen!';

  // Interactive Lesson Instructions & Feedback
  String get moveThe => locale.languageCode == 'mn' ? 'Нүүх: ' : 'Move the ';
  String get lessonComplete => locale.languageCode == 'mn' ? 'Хичээл дууслаа' : 'Lesson Complete';
  String get captureThe => locale.languageCode == 'mn' ? 'Идэх: ' : 'Capture the ';
  String get withYour => locale.languageCode == 'mn' ? ' - өөрийн ' : ' with your ';
  String get castleKingside => locale.languageCode == 'mn' ? 'Богино сэлгээ (Хааныг g1 рүү нүү)' : 'Castle Kingside (Move King to g1)';
  String get castleQueenside => locale.languageCode == 'mn' ? 'Урт сэлгээ (Хааныг c1 рүү нүү)' : 'Castle Queenside (Move King to c1)';
  String get escapeCheck => locale.languageCode == 'mn' ? 'Шагаас гарч байж сэлгэнэ (Сэлгэх боломжгүй)' : 'Escape the check (Cannot castle)';
  String get escapeCheckMove => locale.languageCode == 'mn' ? 'Шагаас гарах (Хааныг нүү)' : 'Escape Check (Move King)';
  String get blockCheck => locale.languageCode == 'mn' ? 'Шагийг хаах (Хүүг c3 рүү нүү)' : 'Block Check (Move Pawn to c3)';
  String get captureAttacker => locale.languageCode == 'mn' ? 'Довтлогчийг идэх (Тэргийг Бэрсээр идэх)' : 'Capture the Attacker (Take Rook with Queen)';
  String get checkmate => locale.languageCode == 'mn' ? 'Мад' : 'Checkmate';
  String get captureEnPassant => locale.languageCode == 'mn' ? 'Эн Пассан идэх (e6 руу нүү)' : 'Capture En Passant (Move to e6)';
  String get value => locale.languageCode == 'mn' ? 'Үнэлгээ' : 'Value';
  String get makeAMove => locale.languageCode == 'mn' ? 'Нүүдэл хийнэ үү' : 'Make a move';

  // Lesson Descriptions
  String get learnPiecesDesc => locale.languageCode == 'mn' 
      ? 'Дүрс бүр хэрхэн нүүдгийг сур. Дүрсүүдийг чирж боломжит нүүдлүүдийг хараарай.' 
      : 'Learn how each piece moves. Drag the pieces to see their valid moves.';
  String get captureDesc => locale.languageCode == 'mn' 
      ? 'Эсрэг талын дүрсийн байрлал дээр бууж иднэ. Идэгдсэн дүрс хөлгөөс гарна.' 
      : 'Capture enemy pieces by moving onto their square. The captured piece is removed from the board.';
  String get castleDesc => locale.languageCode == 'mn' 
      ? 'Сэлгээ нь хааныг хамгаалах тусгай нүүдэл юм. Хааныг тэрэгрүү хоёр нүд нүү.' 
      : 'Castling is a special move to protect your King. Move the King two squares towards a Rook.';
  String get enPassantDesc => locale.languageCode == 'mn' 
      ? 'Хар хүү давж хоёр нүд нүүллээ! Өөрийн хүүг диагоналдаж d6 руу нүүн идээрэй.' 
      : 'The Black Pawn just moved two squares! Capture it by moving your Pawn diagonally to d6.';

  // Step Explanations
  String get pawnMoveExp => locale.languageCode == 'mn' 
      ? 'Хүү зөвхөн урагшаа нэг нүд нүүх боловч, идэхдээ диагоналдаж иднэ.' 
      : 'Pawns move forward one square at a time, but capture diagonally.';
  String get rookMoveExp => locale.languageCode == 'mn' 
      ? 'Тэрэг хэвтээ болон босоо чиглэлд дурын тоогоор нүүнэ.' 
      : 'Rooks move any number of squares horizontally or vertically.';
  String get knightMoveExp => locale.languageCode == 'mn' 
      ? 'Морь "L" хэлбэрээр нүүнэ: хоёр нүд чигээрээ, нэг нүд хажуу тийш. Бусад дүрсийг дээгүүр нь давж чадна.' 
      : 'Knights move in an \'L\' shape: two squares in one direction and then one square perpendicular. They can jump over other pieces.';
  String get bishopMoveExp => locale.languageCode == 'mn' 
      ? 'Тэмээ диагональ чиглэлд дурын тоогоор нүүнэ. Үргэлж ижил өнгийн нүдэн дээр байна.' 
      : 'Bishops move any number of squares diagonally. They stay on squares of the same color.';
  String get queenMoveExp => locale.languageCode == 'mn' 
      ? 'Бэрс бол хамгийн хүчтэй дүрс. Тэр хэвтээ, босоо, диагональ чиглэлд дурын тоогоор нүүж чадна.' 
      : 'The Queen is the most powerful piece. She can move any number of squares in any direction: horizontally, vertically, or diagonally.';
  String get kingMoveExp => locale.languageCode == 'mn' 
      ? 'Ноён аль ч чиглэлд нэг нүд нүүнэ. Тэр бол хамгийн чухал дүрс!' 
      : 'The King moves one square in any direction. He is the most important piece!';
  String get captureExp => locale.languageCode == 'mn' 
      ? 'Идэхийн тулд өөрийн дүрсийг эсрэг талын дүрс байгаа нүдруу нүү.' 
      : 'To capture, move your piece onto the square occupied by the enemy piece.';
  String get kingsideCastleExp => locale.languageCode == 'mn' 
      ? 'Богино сэлгээ нь илүү богино. Хаан баруун тийш хоёр нүд нүүнэ.' 
      : 'Kingside castling is shorter. The King moves two squares to the right.';
  String get queensideCastleExp => locale.languageCode == 'mn' 
      ? 'Урт сэлгээ нь илүү хол. Хаан зүүн тийш хоёр нүд нүүнэ.' 
      : 'Queenside castling is longer. The King moves two squares to the left.';
  String get castleCheckExp => locale.languageCode == 'mn' 
      ? 'Хэрэв хаан шаганд байгаа, эсвэл нүүх замд нь шаг байгаа бол сэлгэж болохгүй.' 
      : 'You cannot castle if your King is in check, or if the King moves through or into check.';
  String get enPassantExp => locale.languageCode == 'mn' 
      ? 'Эн Пассан бол хүүгийн тусгай идэлт. Эсрэг талын хүү хоёр нүд нүүж таны хүүтэй зэрэгцвэл, та түүнийг нэг нүд нүүсэн мэтээр идэж болно.' 
      : 'En Passant is a special pawn capture. If an enemy pawn moves two squares forward and lands next to your pawn, you can capture it as if it had only moved one square.';
  String get checkExp => locale.languageCode == 'mn' 
      ? 'Хаан руу довтолсон үед "Шаг" гэнэ. Та даруй зугтах ёстой.' 
      : 'When your King is under attack, it is in \'Check\'. You must escape immediately.';
  String get blockExp => locale.languageCode == 'mn' 
      ? 'Та довтлогч болон хааны хооронд өөр дүрс тавьж шагийг хааж болно.' 
      : 'You can block a check by placing another piece between the attacker and your King.';
  String get captureCheckExp => locale.languageCode == 'mn' 
      ? 'Та мөн довтлогч дүрсийг идэж шагаас гарч болно.' 
      : 'You can also escape check by capturing the attacking piece.';
  String get checkmateExp => locale.languageCode == 'mn' 
      ? 'Хаан шаганд байгаад зугтах нүүдэлгүй бол "Мад" болно. Тоглоом дуусна.' 
      : 'Checkmate happens when the King is in check and has no legal moves to escape. The game is over.';
  String get pawnValueExp => locale.languageCode == 'mn' 
      ? 'Хүү 1 онооны үнэтэй. Энэ бол үнэ цэнийн үндсэн нэгж.' 
      : 'A Pawn is worth 1 point. It is the basic unit of value.';
  String get minorPieceValueExp => locale.languageCode == 'mn' 
      ? 'Морь болон Тэмээ тус бүр 3 оноо. Эдгээрийг "Хөнгөн бод" гэнэ.' 
      : 'Knights and Bishops are worth 3 points each. They are \'Minor Pieces\'.';
  String get rookValueExp => locale.languageCode == 'mn' 
      ? 'Тэрэг 5 онооны үнэтэй. Энэ бол "Хүнд бод".' 
      : 'A Rook is worth 5 points. It is a \'Major Piece\'.';
  String get queenValueExp => locale.languageCode == 'mn' 
      ? 'Бэрс 9 онооны үнэтэй. Хаанаас гаднах хамгийн үнэ цэнэтэй дүрс.' 
      : 'The Queen is worth 9 points. She is the most valuable piece (besides the King).';

  // Error Messages
  String get captureRookError => locale.languageCode == 'mn' ? 'Хар тэрэг байсаар байна! Түүнийг ид.' : 'You moved, but the Black Rook is still there! Capture it.';
  String get captureBishopError => locale.languageCode == 'mn' ? 'Тэмээ аюулгүй хэвээр байна. Идэхийг оролд!' : 'The Bishop is still safe. Try to capture it!';
  String get captureKnightError => locale.languageCode == 'mn' ? 'Морь зугтчихлаа! Морины буудал дээр буух нүүдэл хай.' : 'The Knight escaped! Look for a move that lands on the Knight\'s square.';
  String get capturePawnError => locale.languageCode == 'mn' ? 'Та хүүг идсэнгүй. Хүү диагоналдаж иддэгийг сана.' : 'You didn\'t capture the pawn. Remember, pawns capture diagonally.';
  String get captureQueenError => locale.languageCode == 'mn' ? 'Бэрс байсаар байна! Түүнийг ид.' : 'The Queen is still there! Capture it.';
  String get captureKingError => locale.languageCode == 'mn' ? 'Хүү байсаар байна! Хаанаараа ид.' : 'The Pawn is still there! Capture it with your King.';
  String get wrongKingside => locale.languageCode == 'mn' ? 'Энэ богино сэлгээ биш байна. Хааныг баруун тийш хоёр нүд нүү.' : 'That\'s not Kingside castling. Move the King two squares to the right.';
  String get wrongQueenside => locale.languageCode == 'mn' ? 'Энэ урт сэлгээ биш байна. Хааныг зүүн тийш хоёр нүд нүү.' : 'That\'s not Queenside castling. Move the King two squares to the left.';
  String get enPassantError => locale.languageCode == 'mn' ? 'Та Эн Пассан хийсэнгүй. Хүүгээ диагоналдаж d6 руу нүү.' : 'You didn\'t capture En Passant. Move your pawn diagonally to d6.';

  // Static Lesson Content
  String get pawnTitle => locale.languageCode == 'mn' ? 'Хүү' : 'Pawn';
  String get pawnDesc => locale.languageCode == 'mn' ? 'Үнэлгээ: 1 Оноо\nХүү бол шатрын явган цэрэг. Тэд олуулаа боловч ганцаараа сул дорой.' : 'Worth: 1 Point\nPawns are the foot soldiers of chess. They are numerous but weak individually.';
  String get knightTitle => locale.languageCode == 'mn' ? 'Морь' : 'Knight';
  String get knightDesc => locale.languageCode == 'mn' ? 'Үнэлгээ: 3 Оноо\nМорь бол харайгч. Тэмээтэй ижил үнэ цэнэтэй.' : 'Worth: 3 Points\nKnights are tricky jumpers. They are equal in value to Bishops.';
  String get bishopTitle => locale.languageCode == 'mn' ? 'Тэмээ' : 'Bishop';
  String get bishopDesc => locale.languageCode == 'mn' ? 'Үнэлгээ: 3 Оноо\nТэмээ диагоналдаж нүүнэ. Морьтой ижил үнэ цэнэтэй.' : 'Worth: 3 Points\nBishops move diagonally. They are equal in value to Knights.';
  String get rookTitle => locale.languageCode == 'mn' ? 'Тэрэг' : 'Rook';
  String get rookDesc => locale.languageCode == 'mn' ? 'Үнэлгээ: 5 Оноо\nТэрэг бол нээлттэй шугамыг хянадаг хүчирхэг дүрс.' : 'Worth: 5 Points\nRooks are powerful pieces that control open lines.';
  String get queenTitle => locale.languageCode == 'mn' ? 'Бэрс' : 'Queen';
  String get queenDesc => locale.languageCode == 'mn' ? 'Үнэлгээ: 9 Оноо\\nБэрс бол Тэрэг болон Тэмээний хүчийг хослуулсан хамгийн хүчтэй дүрс.' : 'Worth: 9 Points\\nThe Queen is the most powerful piece, combining the powers of Rook and Bishop.';
  String get kingTitle => locale.languageCode == 'mn' ? 'Ноён' : 'King';
  
  String get inCheckTitle => locale.languageCode == 'mn' ? 'Шаганд (Зугтах)' : 'In Check (Escape)';
  String get inCheckDesc => locale.languageCode == 'mn' ? 'Хаан e8 дээрх Тэрэгний довтолгоонд байна! Аюулгүй нүд рүү нүүх ёстой.' : 'The King is under attack by the Rook on e8! It must move to a safe square.';
  String get blockCheckTitle => locale.languageCode == 'mn' ? 'Шагийг хаах' : 'Block Check';
  String get blockCheckDesc => locale.languageCode == 'mn' ? 'Хаан a5 дээрх Тэмээний шаганд байна. Цагаан тал хүүгээ c3 руу нүүж хааж чадна.' : 'The King is checked by the Bishop on a5. White can block the attack by moving the pawn to c3.';
  String get captureAttackerTitle => locale.languageCode == 'mn' ? 'Довтлогчийг идэх' : 'Capture the Attacker';
  String get captureAttackerDesc => locale.languageCode == 'mn' ? 'Хаан e2 дээрх Тэрэгний шаганд байна. d1 дээрх Бэрс Тэргийг идэж чадна!' : 'The King is checked by the Rook on e2. The Queen on d1 can capture the Rook!';
  String get checkmateTitle => locale.languageCode == 'mn' ? 'Мад' : 'Checkmate';
  String get checkmateDesc => locale.languageCode == 'mn' ? 'Хаан довтолгоонд өртсөн бөгөөд зугтах газар АЛГА. Тоглоом дууслаа.' : 'The King is under attack and has NO escape. The game is over.';
  String get contentComingSoon => locale.languageCode == 'mn' ? 'Агуулга удахгүй орно!' : 'Content coming soon!';


  // Puzzles
  String get tacticsAndPuzzles => locale.languageCode == 'mn' ? 'Таавар болон Тактик' : 'Tactics & Puzzles';
  String get puzzleDescription => locale.languageCode == 'mn' ? 'Онолын зөв нүүдэл хийж тааврыг бодно уу.' : 'Find the correct sequence to solve the puzzle.';
  String get solvePuzzle => locale.languageCode == 'mn' ? 'Зөв нүүдлийг ол...' : 'Find the best move...';
  String get findMate2 => locale.languageCode == 'mn' ? 'Эсрэг тал нүүлээ, одоо мадлах нүүдлийг ол!' : 'Opponent replied. Now, deliver mate!';
  String get solvePuzzle1 => locale.languageCode == 'mn' ? '1 нүүдлээр мадална уу.' : 'Deliver mate in 1.';
  String get opponentReplied => locale.languageCode == 'mn' ? 'Өрсөлдөгч нүүлээ, дараагийн нүүдлээ үргэлжлүүлнэ үү.' : 'Opponent replied. Continue your moves.';
  
  String get p1_mate_1_back_rank => locale.languageCode == 'mn' ? '1 нүүдлээр мад: Арын шугам' : 'Mate in 1: Back Rank';
  String get p2_mate_1_smothered => locale.languageCode == 'mn' ? '1 нүүдлээр мад: Битүү мад' : 'Mate in 1: Smothered';
  String get p3_mate_1_scholar => locale.languageCode == 'mn' ? '1 нүүдлээр мад: Сурагч мад' : 'Mate in 1: Scholar\'s Mate';
  String get p4_mate_1_queen => locale.languageCode == 'mn' ? '1 нүүдлээр мад: Бэрсийн мад' : 'Mate in 1: Queen Finish';
  String get p5_mate_2_ladder => locale.languageCode == 'mn' ? '2 нүүдлээр мад: Шатлан мадлах' : 'Mate in 2: Ladder Mate';
  String get p6_mate_2_anastasia => locale.languageCode == 'mn' ? '2 нүүдлээр мад: Анастасиягийн мад' : 'Mate in 2: Anastasia\'s Mate';
  String get p7_mate_2_back_rank_sac => locale.languageCode == 'mn' ? '2 нүүдлээр мад: Бэрс золиослох' : 'Mate in 2: Back Rank Sacrifice';
  String get p8_tactic_knight_fork => locale.languageCode == 'mn' ? 'Тактик: Морьны сэрээ' : 'Tactic: Knight Fork';
  String get p9_tactic_discovered_attack => locale.languageCode == 'mn' ? 'Тактик: Нээх довтолгоо' : 'Tactic: Discovered Attack';
  String get p10_tactic_skewer => locale.languageCode == 'mn' ? 'Тактик: Нэвт сүлбэх' : 'Tactic: Skewer';
  String get capturePiece => locale.languageCode == 'mn' ? 'Бодоо ид.' : 'Capture the piece!';

  // Game Page - Time Controls & Dialogs
  String get timeUp => locale.languageCode == 'mn' ? 'Цаг дууслаа!' : 'Time Up!';
  String get timeHasRunOut => locale.languageCode == 'mn' ? 'Цаг дууссан байна.' : 'Time has run out.';
  String get wins => locale.languageCode == 'mn' ? 'хожлоо!' : 'Wins!';
  String checkmateWinner(String winner) => locale.languageCode == 'mn' ? 'Мад! $winner тоглоомыг хожлоо.' : 'Checkmate! $winner has won the game.';
  String get stalemate => locale.languageCode == 'mn' ? 'Тэнцээ' : 'Stalemate';
  String get stalemateDesc => locale.languageCode == 'mn' ? 'Тоглоом тэнцээ болж тэнцлээ.' : 'The game ended in a draw by stalemate.';
  String get adjustClock => locale.languageCode == 'mn' ? 'Цагийг тохируулах' : 'Adjust Clock';
  String get whiteTime => locale.languageCode == 'mn' ? 'Цагааны цаг (минут):' : 'White Time (minutes):';
  String get blackTime => locale.languageCode == 'mn' ? 'Харын цаг (минут):' : 'Black Time (minutes):';
  String get minutes => locale.languageCode == 'mn' ? 'минут' : 'minutes';
  String get apply => locale.languageCode == 'mn' ? 'Болсон' : 'Apply';
  String get check => locale.languageCode == 'mn' ? 'Шаг!' : 'Check!';

  // Feedback & Support Page
  String get emailSupport => locale.languageCode == 'mn' ? 'Имэйл дэмжлэг' : 'Email Support';
  String get emailSupportDesc => locale.languageCode == 'mn' ? 'support@chessdy.com руу имэйл илгээж апп-ын талаар тусламж авна уу.' : 'Send an email to support@chessdy.com for assistance with the app.';
  String get copyEmail => locale.languageCode == 'mn' ? 'Имэйл хуулах' : 'Copy Email';
  String get emailCopied => locale.languageCode == 'mn' ? 'Имэйл хаяг санах ойд хуулагдлаа' : 'Email address copied to clipboard';
  String get leaveReview => locale.languageCode == 'mn' ? 'Үнэлгээ өгөх' : 'Leave a Review';
  String get leaveReviewDesc => locale.languageCode == 'mn' ? 'Chessdy ашигласанд баярлалаа! Таны санал апп-ыг сайжруулахад тусална.' : 'Thank you for using Chessdy! Your feedback helps us improve the app.';
  String get rateOnStore => locale.languageCode == 'mn' ? 'Апп худалдааны төв дээр үнэлнэ үү' : 'Rate us on the App Store / Play Store';
  String get maybeLater => locale.languageCode == 'mn' ? 'Дараагаар' : 'Maybe Later';
  String get rateNow => locale.languageCode == 'mn' ? 'Одоо үнэлэх' : 'Rate Now';
  String get openingAppStore => locale.languageCode == 'mn' ? 'Апп худалдааны төв нээж байна...' : 'Opening app store...';
  String get sendFeedback => locale.languageCode == 'mn' ? 'Санал илгээх' : 'Send Feedback';
  String get yourEmail => locale.languageCode == 'mn' ? 'Таны имэйл (Заавал биш)' : 'Your Email (Optional)';
  String get feedback => locale.languageCode == 'mn' ? 'Санал' : 'Feedback';
  String get tellUsWhatYouThink => locale.languageCode == 'mn' ? 'Юу бодож байгаагаа хэлнэ үү...' : 'Tell us what you think...';
  String get thankYouFeedback => locale.languageCode == 'mn' ? 'Санал өгсөнд баярлалаа!' : 'Thank you for your feedback!';

  // Home Page
  String get aboutChessdy => locale.languageCode == 'mn' ? 'Chessdy-ийн тухай' : 'About Chessdy';
  String get aboutChessdyDesc => locale.languageCode == 'mn' 
      ? 'Chessdy нь шатрыг сурах, бэлтгэл хийх, AI-тай тоглох зориулалттай апп юм.\n\nХувилбар: 1.0.0\n\n© 2024 Chessdy' 
      : 'Chessdy is an app for learning chess, training, and playing against AI.\n\nVersion: 1.0.0\n\n© 2024 Chessdy';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'mn'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
