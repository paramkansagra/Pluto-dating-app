// import 'package:flutter/material.dart';
// import 'package:dash_chat/dash_chat.dart';
// import 'package:sendbird_sdk/sendbird_sdk.dart';

// class chatting extends StatefulWidget {
//   final String appId;
//   final String userId;
//   final List<String> otherUserId;
//   const chatting(
//       {super.key,
//       required this.appId,
//       required this.userId,
//       required this.otherUserId});

//   @override
//   State<chatting> createState() => _chattingState();
// }

// class _chattingState extends State<chatting> with ChannelEventHandler {
  
//   List<BaseMessage> _messages = [];
//   GroupChannel? _channel;
    
//   void load() async {
//     try {
//       final sendbird = SendbirdSdk(appId: widget.appId);
//       final _ = await sendbird.connect(widget.userId);

//       //get an existing channel
//       final query = GroupChannelListQuery()
//         ..limit = 1
//         ..userIdsExactlyIn = widget.otherUserId;

//       List<GroupChannel> channels = await query.loadNext();
//       GroupChannel aChannel;

//       if (channels.isEmpty) {
//         //create new channel
//         aChannel = await GroupChannel.createChannel(GroupChannelParams()
//           ..userIds = widget.otherUserId + [widget.userId]);
//       } else {
//         aChannel = channels[0];
//       }

//       //get message from channel
//       List<BaseMessage> messages = await aChannel.getMessagesByTimestamp(
//           DateTime.now().microsecondsSinceEpoch * 1000, MessageListParams());

//       setState(() {
//         _messages = messages;
//         _channel = aChannel;
//       });
//     } catch (e) {
//       print("There is an error connect with sendbord");
//       print(e);
//     }
//   }

//   ChatUser asDashUser(User? user) {
//     if (user == Null) {
//       return ChatUser(uid: "", name: "", avatar: "");
//     }

//     return ChatUser(
//       uid: user!.userId,
//       name: user.nickname,
//       avatar: user.profileUrl,
//     );
//   }

//   List<ChatMessage> aDashChatMessage(List<BaseMessage> messages) {
//     return [
//       for (BaseMessage sbm in messages)
//         ChatMessage(text: sbm.message, user: asDashUser(sbm.sender))
//     ];
//   }

//   @override
//   void initState() {
//     load();
//     SendbirdSdk().addChannelEventHandler("chat", this);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     SendbirdSdk().removeChannelEventHandler("chat");
//     super.dispose();
//   }

//   @override
//   void onMessageReceived(BaseChannel channel, BaseMessage message) {
//     setState(() {
//       _messages.add(message);
//     });
//     super.onMessageReceived(channel, message);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("SendBird SDK"),
//       ),
//       body: DashChat(
//           messages: aDashChatMessage(_messages),
//           user: ChatUser(uid: "", name: "", avatar: ""),
//           onSend: (newMessage) {
//             // final message = _channel.sendUserMessage

//             print(newMessage);
//           }),
//     );
//   }
// }
