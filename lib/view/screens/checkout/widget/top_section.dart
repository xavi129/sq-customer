import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:sq_customer/controller/auth_controller.dart';
import 'package:sq_customer/controller/location_controller.dart';
import 'package:sq_customer/controller/order_controller.dart';
import 'package:sq_customer/controller/splash_controller.dart';
import 'package:sq_customer/controller/store_controller.dart';
import 'package:sq_customer/data/model/response/address_model.dart';
import 'package:sq_customer/data/model/response/cart_model.dart';
import 'package:sq_customer/data/model/response/config_model.dart';
import 'package:sq_customer/helper/price_converter.dart';
import 'package:sq_customer/helper/responsive_helper.dart';
import 'package:sq_customer/helper/route_helper.dart';
import 'package:sq_customer/util/dimensions.dart';
import 'package:sq_customer/util/styles.dart';
import 'package:sq_customer/util/images.dart';
import 'package:sq_customer/view/base/custom_dropdown.dart';
import 'package:sq_customer/view/screens/cart/widget/delivery_option_button.dart';
import 'package:sq_customer/view/screens/checkout/widget/coupon_section.dart';
import 'package:sq_customer/view/screens/checkout/widget/delivery_instruction_view.dart';
import 'package:sq_customer/view/screens/checkout/widget/delivery_section.dart';
import 'package:sq_customer/view/screens/checkout/widget/deliveryman_tips_section.dart';
import 'package:sq_customer/view/screens/checkout/widget/partial_pay_view.dart';
import 'package:sq_customer/view/screens/checkout/widget/payment_section.dart';
import 'package:sq_customer/view/screens/checkout/widget/time_slot_section.dart';
import 'package:sq_customer/view/screens/checkout/widget/web_delivery_instruction_view.dart';
import 'package:sq_customer/view/screens/store/widget/camera_button_sheet.dart';
import 'dart:io';

class TopSection extends StatefulWidget {
  final StoreController storeController;
  final double charge;
  final double deliveryCharge;
  final OrderController orderController;
  final LocationController locationController;
  final List<DropdownItem<int>> addressList;
  final bool tomorrowClosed;
  final bool todayClosed;
  final Module? module;
  final double price;
  final double discount;
  final double addOns;
  final int? storeId;
  final List<AddressModel> address;
  final List<CartModel?>? cartList;
  final bool isCashOnDeliveryActive;
  final bool isDigitalPaymentActive;
  final bool isWalletActive;
  final double total;
  final bool isOfflinePaymentActive;
  final TextEditingController guestNameTextEditingController;
  final TextEditingController guestNumberTextEditingController;
  final TextEditingController guestEmailController;
  final FocusNode guestNumberNode;
  final FocusNode guestEmailNode;
  final JustTheController tooltipController1;
  final JustTheController tooltipController2;
  final JustTheController dmTipsTooltipController;

  const TopSection({
    Key? key,
    required this.deliveryCharge,
    required this.charge,
    required this.tomorrowClosed,
    required this.todayClosed,
    required this.price,
    required this.discount,
    required this.addOns,
    required this.addressList,
    required this.storeController,
    required this.orderController,
    required this.locationController,
    this.module,
    this.storeId,
    required this.address,
    required this.cartList,
    required this.isCashOnDeliveryActive,
    required this.isDigitalPaymentActive,
    required this.isWalletActive,
    required this.total,
    required this.isOfflinePaymentActive,
    required this.guestNameTextEditingController,
    required this.guestNumberTextEditingController,
    required this.guestNumberNode,
    required this.guestEmailController,
    required this.guestEmailNode,
    required this.tooltipController1,
    required this.tooltipController2,
    required this.dmTipsTooltipController,
  }) : super(key: key);

  @override
  _TopSectionState createState() => _TopSectionState();
}

class _TopSectionState extends State<TopSection> {
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    // Mostrar el diálogo después de que el widget se haya renderizado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_dialogShown) {
        _mostrarDialogoDireccion(context);
        _dialogShown = true;
      }
    });
  }

  void _mostrarDialogoDireccion(BuildContext context) {
    showDialog(
      context: context,
      builder: (modalContext) => Center(
        child: Container(
          width: 250, // Ancho fijo para reducir el tamaño del cuadro entero
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                Images.address, // Asegúrate de agregar esta imagen en tu carpeta de assets
                height: 40, // Tamaño reducido de la imagen
              ),
              const SizedBox(height: 10),
              Text(
                '¿Dirección correcta?',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Supongamos que tienes la lista 'address' disponible
              Text(
                '${widget.address[0].address}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      // Acción para confirmar la dirección
                      Navigator.of(modalContext).pop();
                    },
                    child: const Text(
                      'Sí',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  const VerticalDivider(width: 1, thickness: 1),
                  TextButton(
                    onPressed: () {
                      // Acción para editar la dirección
                    Get.toNamed(RouteHelper.getAddAddressRoute(false, false, 0));
                      // Aquí puedes realizar otra acción, como abrir otro modal para editar la dirección
                    },
                    child: const Text(
                      'Editar',
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool takeAway = (widget.orderController.orderType == 'take_away');
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    bool isGuestLoggedIn = Get.find<AuthController>().isGuestLoggedIn();

    return Container(
      decoration: isDesktop
          ? BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)
              ],
            )
          : null,
      child: Column(
        children: [
          widget.storeId != null
              ? Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.05),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeLarge,
                    vertical: Dimensions.paddingSizeSmall,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('your_prescription'.tr, style: robotoMedium),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          JustTheTooltip(
                            backgroundColor: Colors.black87,
                            controller: widget.tooltipController1,
                            preferredDirection: AxisDirection.right,
                            tailLength: 14,
                            tailBaseWidth: 20,
                            content: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'prescription_tool_tip'.tr,
                                style: robotoRegular.copyWith(color: Colors.white),
                              ),
                            ),
                            child: InkWell(
                              onTap: () => widget.tooltipController1.showTooltip(),
                              child: const Icon(Icons.info_outline),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: widget.storeController.pickedPrescriptions.length + 1,
                          itemBuilder: (context, index) {
                            if (index < widget.storeController.pickedPrescriptions.length) {
                              XFile file = widget.storeController.pickedPrescriptions[index];
                              // Personaliza cómo se muestra cada prescripción
                              return Container(
                                margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                ),
                                child: DottedBorder(
                                  color: Theme.of(context).primaryColor,
                                  strokeWidth: 1,
                                  strokeCap: StrokeCap.butt,
                                  dashPattern: const [5, 5],
                                  padding: const EdgeInsets.all(0),
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(Dimensions.radiusDefault),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                          child: GetPlatform.isWeb
                                              ? Image.network(
                                                  file.path,
                                                  width: 98,
                                                  height: 98,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.file(
                                                  File(file.path),
                                                  width: 98,
                                                  height: 98,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: InkWell(
                                            onTap: () => widget.storeController.removePrescriptionImage(index),
                                            child: const Padding(
                                              padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                              child: Icon(Icons.delete_forever, color: Colors.red),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              // Contenedor de subida siempre visible
                              return InkWell(
                                onTap: () {
                                  _mostrarDialogoDireccion(context);
                                },
                                child: DottedBorder(
                                  color: Theme.of(context).primaryColor,
                                  strokeWidth: 1,
                                  strokeCap: StrokeCap.butt,
                                  dashPattern: const [5, 5],
                                  padding: const EdgeInsets.all(0),
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(Dimensions.radiusDefault),
                                  child: Container(
                                    height: 98,
                                    width: 98,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.cloud_upload,
                                          color: Theme.of(context).disabledColor,
                                          size: 32,
                                        ),
                                        Text(
                                          'upload_your_prescription'.tr,
                                          style: robotoRegular.copyWith(
                                            color: Theme.of(context).disabledColor,
                                            fontSize: Dimensions.fontSizeSmall,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          // Opciones de entrega
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.05),
                  blurRadius: 10,
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeLarge,
              vertical: Dimensions.paddingSizeSmall,
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('delivery_type'.tr, style: robotoMedium),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                widget.storeId != null
                    ? DeliveryOptionButton(
                        value: 'delivery',
                        title: 'home_delivery'.tr,
                        charge: widget.charge,
                        isFree: widget.storeController.store!.freeDelivery,
                        fromWeb: true,
                        total: widget.total,
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Get.find<SplashController>().configModel!.homeDeliveryStatus == 1 &&
                                    widget.storeController.store!.delivery!
                                ? DeliveryOptionButton(
                                    value: 'delivery',
                                    title: 'home_delivery'.tr,
                                    charge: widget.charge,
                                    isFree: widget.storeController.store!.freeDelivery,
                                    fromWeb: true,
                                    total: widget.total,
                                  )
                                : const SizedBox(),
                            const SizedBox(width: Dimensions.paddingSizeDefault),
                            Get.find<SplashController>().configModel!.takeawayStatus == 1 &&
                                    widget.storeController.store!.takeAway!
                                ? DeliveryOptionButton(
                                    value: 'take_away',
                                    title: 'take_away'.tr,
                                    charge: widget.deliveryCharge,
                                    isFree: true,
                                    fromWeb: true,
                                    total: widget.total,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
         !takeAway && !isGuestLoggedIn
    ? Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${'delivery_charge'.tr}: '),
            Text(
              widget.storeController.store!.freeDelivery!
                  ? 'free'.tr
                  : widget.orderController.distance != -1
                      ? PriceConverter.convertPrice(widget.charge)
                      : 'calculating'.tr,
              textDirection: TextDirection.ltr,
            ),
          ],
        ),
      )
    : const SizedBox(),
SizedBox(height: !takeAway && !isGuestLoggedIn ? Dimensions.paddingSizeLarge : 0),

// Sección de entrega
DeliverySection(
  orderController: widget.orderController,
  storeController: widget.storeController,
  address: widget.address,
  addressList: widget.addressList,
  guestNameTextEditingController: widget.guestNameTextEditingController,
  guestNumberTextEditingController: widget.guestNumberTextEditingController,
  guestNumberNode: widget.guestNumberNode,
  guestEmailController: widget.guestEmailController,
  guestEmailNode: widget.guestEmailNode,
),

        SizedBox(
  height: !takeAway
      ? (isDesktop ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall)
      : 0,
),

/// Instrucciones de entrega
!takeAway
    ? (isDesktop
        ? const WebDeliveryInstructionView()
        : const DeliveryInstructionView())
    : const SizedBox(),

SizedBox(height: !takeAway ? Dimensions.paddingSizeSmall : 0),

/// Time Slot
TimeSlotSection(
  storeId: widget.storeId,
  storeController: widget.storeController,
  cartList: widget.cartList,
  tooltipController2: widget.tooltipController2,
  tomorrowClosed: widget.tomorrowClosed,
  todayClosed: widget.todayClosed,
  module: widget.module,
  orderController: widget.orderController,
),

/// Cupón
!isDesktop && !isGuestLoggedIn
    ? CouponSection(
        storeId: widget.storeId,
        orderController: widget.orderController,
        total: widget.total,
        price: widget.price,
        discount: widget.discount,
        addOns: widget.addOns,
        deliveryCharge: widget.deliveryCharge,
      )
    : const SizedBox(),

/// Propinas al repartidor
DeliveryManTipsSection(
  takeAway: takeAway,
  tooltipController3: widget.dmTipsTooltipController,
  totalPrice: widget.total,
  onTotalChange: (double price) => widget.total + price,
  storeId: widget.storeId,
),

/// Pago
Container(
  decoration: isDesktop
      ? const BoxDecoration()
      : BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              blurRadius: 10,
            )
          ],
        ),
  padding: const EdgeInsets.symmetric(
    vertical: Dimensions.paddingSizeLarge,
    horizontal: Dimensions.paddingSizeLarge,
  ),
  child: Column(
    children: [
      PaymentSection(
        storeId: widget.storeId,
        isCashOnDeliveryActive: widget.isCashOnDeliveryActive,
        isDigitalPaymentActive: widget.isDigitalPaymentActive,
        isWalletActive: widget.isWalletActive,
        total: widget.total,
        orderController: widget.orderController,
        isOfflinePaymentActive: widget.isOfflinePaymentActive,
      ),
      SizedBox(
        height: isGuestLoggedIn ? 0 : Dimensions.paddingSizeLarge,
      ),
      !isDesktop && !isGuestLoggedIn
          ? PartialPayView(
              totalPrice: widget.total,
              isPrescription: widget.storeId != null,
            )
          : const SizedBox(),
    ],
  ),
),
SizedBox(height: isDesktop ? Dimensions.paddingSizeLarge : 0),


      ]),
    );
  }
}