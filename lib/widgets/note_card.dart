import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encryptor/encryptor.dart';
import 'package:flutter/material.dart';

import '../style/app_style.dart';

Widget noteCard(Function()? onTap, QueryDocumentSnapshot doc, String? key) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppStyle.cardsColor[doc['color_id']],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Encryptor.decrypt(key!, doc['note_title']),
            style: AppStyle.mainTitle,
          ),
          const SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: Text(
              Encryptor.decrypt(key, doc['note_content']),
              style: AppStyle.mainContent,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}
