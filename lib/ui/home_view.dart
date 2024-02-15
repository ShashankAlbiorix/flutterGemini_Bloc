import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../bloc/home_bloc.dart';
import '../models/chatMessageModel.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _textController = TextEditingController();
  final textEditingFocusNode = FocusNode();
  ScrollController scrollViewController = ScrollController();

  final HomeBloc homeBloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Gemini With Bloc",style: TextStyle(color: Color(0xffDBE7C9)),),
        backgroundColor: const Color(0xff294B29),
      ),
      backgroundColor: const Color(0xff789461),
      body: Stack(
        children: [
          Image.asset(
            "assets/images/background.jpg",
            fit: BoxFit.cover,
            color:  const Color(0xff789461),
            colorBlendMode:BlendMode.screen,
            height: MediaQuery.of(context).size.height,
          ),
          BlocConsumer<HomeBloc, HomeState>(
            bloc: homeBloc,
            listener: (context, state) {
              if(state is HomeLoaded){
                if(scrollViewController.hasClients){
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    scrollViewController.animateTo(
                        scrollViewController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn);
                  });
                }

              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        controller: scrollViewController,
                        itemCount:homeBloc.listMessage.length,
                        itemBuilder: (ctx, index) {
                          return Align(
                            alignment:homeBloc.listMessage[index].isUser ?? false ? Alignment.centerRight:Alignment.centerLeft ,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width *0.80
                              ),
                              child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(
                                          homeBloc.listMessage[index].isUser ??false
                                              ? 10
                                              : 0,
                                        ),
                                        topLeft: const Radius.circular(10),
                                        topRight: const Radius.circular(10),
                                        bottomRight: Radius.circular(
                                          homeBloc.listMessage[index].isUser ?? false
                                              ? 0
                                              : 10,
                                        ),
                                      ),
                                      color: homeBloc.listMessage[index].isUser ?? false ? const Color(0xffDBE7C9).withOpacity(0.9) : const Color(0xff294B29).withOpacity(0.9)
                                  ),
                                  child: Text(homeBloc.listMessage[index].msgContent.toString(),style:  TextStyle(fontSize: 18,color: homeBloc.listMessage[index].isUser ?? false ?const Color(0xff294B29) : Colors.white),)),
                            ),
                          );
                        }),
                  ),
                  Visibility(
                    visible: state is HomeLoading,
                    child: SizedBox(
                      height: 30,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color:
                                Colors.white.withOpacity(0.8),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(0),
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: LoadingAnimationWidget.staggeredDotsWave(
                                  color: Colors.teal,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow:  const [
                          BoxShadow(
                            color: Color(0xff50623A),
                            offset: Offset(
                              5.0,
                              8.0,
                            ),
                            blurRadius: 5.0,
                            spreadRadius: 0.0,
                          )
                        ],
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: const Color(0xff294B29))),
                    child: Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _textController,
                              focusNode: textEditingFocusNode,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter Message"),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              textEditingFocusNode.unfocus();
                              homeBloc.listMessage.add(ChatMessageModel(msgContent: _textController.text,isUser: true,timestamp: DateTime.now().millisecondsSinceEpoch));
                            });
                            if(scrollViewController.hasClients){
                              SchedulerBinding.instance.addPostFrameCallback((_) {
                                scrollViewController.animateTo(
                                    scrollViewController.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.fastOutSlowIn);
                              });
                            }
                            homeBloc
                                .add(MessageSentEvent(_textController.text));
                            _textController.clear();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.send_rounded,
                              size: 40,
                              color: Color(0xff294B29),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
