import 'package:flutter/material.dart';
import 'package:sweet_shop/models/cart_model.dart';

class PrevOrderDetailsCard extends StatefulWidget {
  final bool adminSide;
  final OrderMOdel order;
  final VoidCallback onOrderComplete; // Add this line

  const PrevOrderDetailsCard(
      {super.key,
      required this.order,
      required this.adminSide,
      required this.onOrderComplete}); // Modify constructor

  @override
  State<PrevOrderDetailsCard> createState() => _PrevOrderDetailsCardState();
}

class _PrevOrderDetailsCardState extends State<PrevOrderDetailsCard> {
  bool updating = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.adminSide
          ? MediaQuery.of(context).size.height / 2.4
          : MediaQuery.of(context).size.height / 5.7,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        fit: BoxFit.contain,
                        widget.order.sweetcart.image,
                        width: MediaQuery.of(context).size.width / 3,
                        height: widget.adminSide ? 150 : 95,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          widget.order.sweetcart.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '₹${widget.order.sweetcart.price * widget.order.quantity * (widget.order.weight / 250)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.order.quantity * widget.order.weight / 1000} Kg',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Order Date : ${widget.order.date.split('T')[0]}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              if (widget.adminSide)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name : ${widget.order.customerName}"),
                          Text("Phone no : ${widget.order.phoneNo}"),
                          SizedBox(
                            width: MediaQuery.of(context).size.width -
                                40, // Adjust width as needed
                            child: Text(
                              "Address : ${widget.order.address}",
                              softWrap: true,
                            ),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(60, 35),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              side: const BorderSide(color: Colors.red),
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () async {
                              setState(() {
                                updating = true;
                              });
                              bool x = await OrderMOdel.markOrderComplete(
                                  widget.order.id!);
                              if (x) {
                                widget.onOrderComplete(); // Call the callback
                                setState(() {
                                  updating = false;
                                });
                              }
                            },
                            child: updating
                                ? const Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  )
                                : const Text(
                                    'Order Complete',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
