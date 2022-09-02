import 'package:admin/configs/constants.dart';
import 'package:admin/controllers/firestore_controller.dart';
import 'package:admin/models/visit_model/diagnosis%20and%20prescription/diagnosis_model.dart';
import 'package:admin/models/visit_model/pharma_billings/pharma_billing_item_model.dart';
import 'package:admin/models/visit_model/pharma_billings/pharma_billing_model.dart';
import 'package:admin/models/visit_model/prescription/prescription_medicine_dose_model.dart';
import 'package:admin/models/visit_model/visit_billings/visit_billing_model.dart';
import 'package:admin/models/visit_model/visit_model.dart';
import 'package:admin/utils/logger_service.dart';
import 'package:admin/utils/my_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/visit_model/prescription/prescription_model.dart';

class VisitController {
  Future<void> createDummyVisitDataInFirestore() async {
    VisitModel visitModel = VisitModel(
      id: MyUtils.getUniqueIdFromUuid(),
      patientId: "tBDre2xeNpifcG6wZYiv",
      description: "High Fever",
      createdTime: Timestamp.now(),
      updatedTime: Timestamp.now(),
      doctors: {
        AdminUserType.admin : "gjf3Mx4YV1TzAyP7xm0N",
      },
      weight: 70,
      currentDoctor: "gjf3Mx4YV1TzAyP7xm0N",
      active: true,
      diagnosis: [
        DiagnosisModel(
          doctorId: "gjf3Mx4YV1TzAyP7xm0N",
          diagnosisDescription: "Patient must have food poison",
          prescription: [
            PrescriptionModel(
              medicineName: "Calpol 650",
              isLiquidMedicine: false,
              isOneTimeBuyMedicine: false,
              doses: [
                PrescriptionMedicineDoseModel(
                  doseTime: PrescriptionMedicineDoseTime.morning,
                  dose: "1",
                  afterMeal: true,
                ),
                PrescriptionMedicineDoseModel(
                  doseTime: PrescriptionMedicineDoseTime.night,
                  dose: "1",
                  afterMeal: true,
                ),
              ],
              repeatDurationDays: 1,
              totalDays: 5,
              totalDose: "10",
            ),
            PrescriptionModel(
              medicineName: "Cloben G",
              isLiquidMedicine: false,
              isOneTimeBuyMedicine: true,
              doses: [
                PrescriptionMedicineDoseModel(
                  doseTime: PrescriptionMedicineDoseTime.morning,
                  dose: "1",
                ),
                PrescriptionMedicineDoseModel(
                  doseTime: PrescriptionMedicineDoseTime.night,
                  dose: "1",
                ),
              ],
              repeatDurationDays: 1,
              totalDose: "1",
              totalDays: 10,
            ),
            PrescriptionModel(
              medicineName: "Cough Syrup",
              isLiquidMedicine: true,
              isOneTimeBuyMedicine: true,
              doses: [
                PrescriptionMedicineDoseModel(
                  doseTime: PrescriptionMedicineDoseTime.morning,
                  dose: "20 ml",
                  afterMeal: false,
                ),
                PrescriptionMedicineDoseModel(
                  doseTime: PrescriptionMedicineDoseTime.night,
                  dose: "20 ml",
                  afterMeal: true,
                ),
              ],
              repeatDurationDays: 1,
              totalDose: "200 ml",
              totalDays: 10,
            ),
          ],
        ),
      ],
      visitBillings: {
        "gjf3Mx4YV1TzAyP7xm0N" : VisitBillingModel(
          doctorId: "gjf3Mx4YV1TzAyP7xm0N",
          createdTime: Timestamp.now(),
          fee: 600,
          discount: 100,
          totalFees: 500,
          paymentMode: PaymentModes.cash,
          paymentId: "Cash",
        ),
      },
      pharmaBilling: PharmaBillingModel(
        patientId: "tBDre2xeNpifcG6wZYiv",
        createdTime: Timestamp.now(),
        baseAmount: 1800,
        discount: 450,
        totalAmount: 1350,
        paymentMode: PaymentModes.upi,
        paymentId: "Gpay_1234xyz",
        paymentStatus: PaymentStatus.paid,
        items: [
          PharmaBillingItemModel(
            medicineName: "Calpol 650",
            dose: "10",
            dosePerUnit: "5",
            unitCount: 2,
            price: 10,
            discount: 0,
            finalAmount: 20,
          ),
          PharmaBillingItemModel(
            medicineName: "Cloben G",
            dose: "1",
            dosePerUnit: "1",
            unitCount: 1,
            price: 600,
            discount: 0,
            finalAmount: 600,
          ),
          PharmaBillingItemModel(
            medicineName: "Cough Syrup",
            dose: "1",
            dosePerUnit: "1",
            unitCount: 1,
            price: 1200,
            discount: 0,
            finalAmount: 1200,
          ),
        ],
      ),
      previousVisitId: "",
    );

    await FirestoreController().firestore.collection(FirebaseNodes.visitsCollection).doc(visitModel.id).set(visitModel.toMap()).then((value) {
      Log().i("Visit Created Successfully with id:${visitModel.id}");
    })
    .catchError((e, s) {
      Log().e(e, s);
    });
  }
}