;; Medical Transport Dispatch Contract
;; Volunteer driver coordination and wheelchair-accessible vehicle sharing
;; Real-time dispatch system with priority-based appointment matching

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only u500)
(define-constant err-unauthorized u501)
(define-constant err-not-found u502)
(define-constant err-already-exists u503)
(define-constant err-invalid-input u504)
(define-constant err-driver-unavailable u505)
(define-constant err-vehicle-unavailable u506)
(define-constant err-appointment-conflict u507)
(define-constant err-insufficient-rating u508)
(define-constant err-trip-in-progress u509)
(define-constant err-background-check-failed u510)

;; Data Variables
(define-data-var driver-counter uint u0)
(define-data-var patient-counter uint u0)
(define-data-var vehicle-counter uint u0)
(define-data-var trip-counter uint u0)
(define-data-var appointment-counter uint u0)
(define-data-var total-drivers uint u0)
(define-data-var total-patients uint u0)
(define-data-var total-vehicles uint u0)
(define-data-var completed-trips uint u0)
(define-data-var emergency-contact principal contract-owner)

;; Data Maps
;; Volunteer driver registry with background check tracking
(define-map drivers
  { driver-id: uint }
  {
    user: principal,
    name: (string-ascii 100),
    phone: (string-ascii 20),
    license-number: (string-ascii 30),
    license-expiry: uint,
    background-check-date: uint,
    background-check-status: (string-ascii 20), ;; pending, approved, rejected
    medical-transport-certification: bool,
    wheelchair-training-certified: bool,
    emergency-response-trained: bool,
    availability-schedule: (string-ascii 200),
    preferred-service-areas: (string-ascii 150),
    maximum-distance: uint, ;; miles
    vehicle-access: (list 10 uint), ;; vehicle IDs they can drive
    total-trips-completed: uint,
    average-rating: uint, ;; 1-5 scale
    rating-count: uint,
    last-active: uint,
    active: bool,
    emergency-contact: (string-ascii 100)
  }
)

;; Patient registration and medical transport needs
(define-map patients
  { patient-id: uint }
  {
    user: principal,
    name: (string-ascii 100),
    phone: (string-ascii 20),
    emergency-contact: (string-ascii 100),
    mobility-needs: (string-ascii 100), ;; wheelchair, walker, none, oxygen
    medical-conditions: (string-ascii 200),
    preferred-language: (string-ascii 30),
    home-address: (string-ascii 200),
    insurance-info: (string-ascii 100),
    accessibility-requirements: (string-ascii 150),
    frequent-destinations: (string-ascii 300), ;; common medical facilities
    caregivers: (list 5 principal), ;; family members who can coordinate
    total-rides-taken: uint,
    last-appointment: uint,
    preferred-drivers: (list 5 uint),
    active: bool,
    registration-date: uint
  }
)

;; Wheelchair-accessible vehicle fleet management
(define-map vehicles
  { vehicle-id: uint }
  {
    owner: principal, ;; can be driver or organization
    vehicle-type: (string-ascii 50), ;; sedan, van, wheelchair-accessible
    make-model: (string-ascii 100),
    year: uint,
    license-plate: (string-ascii 15),
    vin-number: (string-ascii 30),
    insurance-policy: (string-ascii 50),
    insurance-expiry: uint,
    inspection-date: uint,
    inspection-expiry: uint,
    wheelchair-accessible: bool,
    wheelchair-capacity: uint, ;; number of wheelchairs
    stretcher-compatible: bool,
    oxygen-equipment-compatible: bool,
    gps-tracking-enabled: bool,
    maintenance-schedule: (string-ascii 200),
    last-maintenance: uint,
    next-maintenance: uint,
    current-mileage: uint,
    availability-status: (string-ascii 20), ;; available, in-use, maintenance
    current-location: (string-ascii 100), ;; city or facility
    assigned-driver: (optional uint)
  }
)

;; Medical appointment scheduling and coordination
(define-map appointments
  { appointment-id: uint }
  {
    patient-id: uint,
    healthcare-facility: (string-ascii 150),
    facility-address: (string-ascii 200),
    appointment-date: uint,
    appointment-time: (string-ascii 10), ;; HH:MM format
    appointment-type: (string-ascii 50), ;; routine, urgent, emergency
    estimated-duration: uint, ;; minutes
    pickup-address: (string-ascii 200),
    special-instructions: (string-ascii 300),
    mobility-requirements: (string-ascii 100),
    medical-equipment-needed: (string-ascii 150),
    preferred-arrival-time: (string-ascii 10),
    return-trip-needed: bool,
    return-pickup-time: (string-ascii 10),
    caregiver-accompanying: bool,
    priority-level: uint, ;; 1-5, with 5 being highest priority
    confirmed: bool,
    assigned-driver: (optional uint),
    assigned-vehicle: (optional uint),
    created-date: uint,
    last-updated: uint
  }
)

;; Trip dispatch and tracking system
(define-map trips
  { trip-id: uint }
  {
    appointment-id: uint,
    driver-id: uint,
    vehicle-id: uint,
    patient-id: uint,
    trip-type: (string-ascii 20), ;; pickup, return, emergency
    pickup-address: (string-ascii 200),
    destination-address: (string-ascii 200),
    scheduled-pickup-time: uint,
    actual-pickup-time: uint,
    scheduled-arrival-time: uint,
    actual-arrival-time: uint,
    trip-status: (string-ascii 20), ;; scheduled, in-progress, completed, cancelled
    distance-miles: uint,
    estimated-duration: uint, ;; minutes
    actual-duration: uint, ;; minutes
    route-taken: (string-ascii 300),
    passenger-count: uint, ;; including caregivers
    special-equipment-used: (string-ascii 150),
    trip-notes: (string-ascii 400),
    patient-rating: uint, ;; 1-5 scale
    driver-rating: uint, ;; 1-5 scale
    incident-reported: bool,
    incident-details: (string-ascii 300),
    trip-cost: uint,
    reimbursement-amount: uint,
    completed-date: uint
  }
)

;; Emergency dispatch and rapid response coordination
(define-map emergency-dispatches
  { emergency-id: uint }
  {
    patient-id: uint,
    emergency-type: (string-ascii 50), ;; medical, dialysis, urgent-care
    urgency-level: uint, ;; 1-5, with 5 being most critical
    pickup-location: (string-ascii 200),
    destination-facility: (string-ascii 150),
    medical-condition: (string-ascii 200),
    special-requirements: (string-ascii 200),
    requested-time: uint,
    dispatcher: principal,
    available-drivers: (list 10 uint),
    assigned-driver: (optional uint),
    assigned-vehicle: (optional uint),
    response-time: uint, ;; minutes to assign driver
    dispatch-status: (string-ascii 20), ;; pending, assigned, in-progress, completed
    family-notified: bool,
    healthcare-facility-notified: bool,
    created-timestamp: uint
  }
)

;; Driver performance and safety tracking
(define-map driver-performance
  { driver-id: uint, month: uint }
  {
    trips-completed: uint,
    total-miles: uint,
    on-time-percentage: uint,
    patient-satisfaction-avg: uint,
    safety-incidents: uint,
    cancellation-rate: uint,
    hours-volunteered: uint,
    special-accommodations: uint, ;; wheelchair, stretcher trips
    emergency-responses: uint,
    training-hours: uint,
    community-recognition: bool
  }
)

;; Public Functions

;; Register as volunteer driver
(define-public (register-driver (name (string-ascii 100))
                               (phone (string-ascii 20))
                               (license-number (string-ascii 30))
                               (license-expiry uint)
                               (availability-schedule (string-ascii 200))
                               (service-areas (string-ascii 150))
                               (max-distance uint)
                               (driver-emergency-contact (string-ascii 100)))
  (let (
    (new-driver-id (+ (var-get driver-counter) u1))
    (current-block stacks-block-height)
  )
    ;; Validate inputs
    (asserts! (> (len name) u0) (err err-invalid-input))
    (asserts! (> license-expiry current-block) (err err-invalid-input))
    (asserts! (> max-distance u0) (err err-invalid-input))
    ;; Register driver
    (map-set drivers { driver-id: new-driver-id }
      {
        user: tx-sender,
        name: name,
        phone: phone,
        license-number: license-number,
        license-expiry: license-expiry,
        background-check-date: u0,
        background-check-status: "pending",
        medical-transport-certification: false,
        wheelchair-training-certified: false,
        emergency-response-trained: false,
        availability-schedule: availability-schedule,
        preferred-service-areas: service-areas,
        maximum-distance: max-distance,
        vehicle-access: (list),
        total-trips-completed: u0,
        average-rating: u5, ;; Default good rating
        rating-count: u0,
        last-active: current-block,
        active: false, ;; Becomes active after background check
        emergency-contact: driver-emergency-contact
      }
    )
    ;; Update counters
    (var-set driver-counter new-driver-id)
    (var-set total-drivers (+ (var-get total-drivers) u1))
    (ok new-driver-id)
  )
)

;; Register patient for medical transport services
(define-public (register-patient (name (string-ascii 100))
                                (phone (string-ascii 20))
                                (patient-emergency-contact (string-ascii 100))
                                (mobility-needs (string-ascii 100))
                                (medical-conditions (string-ascii 200))
                                (home-address (string-ascii 200))
                                (accessibility-requirements (string-ascii 150)))
  (let (
    (new-patient-id (+ (var-get patient-counter) u1))
    (current-block stacks-block-height)
  )
    ;; Validate inputs
    (asserts! (> (len name) u0) (err err-invalid-input))
    (asserts! (> (len phone) u5) (err err-invalid-input))
    ;; Register patient
    (map-set patients { patient-id: new-patient-id }
      {
        user: tx-sender,
        name: name,
        phone: phone,
        emergency-contact: patient-emergency-contact,
        mobility-needs: mobility-needs,
        medical-conditions: medical-conditions,
        preferred-language: "English",
        home-address: home-address,
        insurance-info: "",
        accessibility-requirements: accessibility-requirements,
        frequent-destinations: "",
        caregivers: (list),
        total-rides-taken: u0,
        last-appointment: u0,
        preferred-drivers: (list),
        active: true,
        registration-date: current-block
      }
    )
    ;; Update counters
    (var-set patient-counter new-patient-id)
    (var-set total-patients (+ (var-get total-patients) u1))
    (ok new-patient-id)
  )
)

;; Register wheelchair-accessible vehicle
(define-public (register-vehicle (vehicle-type (string-ascii 50))
                                (make-model (string-ascii 100))
                                (year uint)
                                (license-plate (string-ascii 15))
                                (wheelchair-accessible bool)
                                (wheelchair-capacity uint)
                                (stretcher-compatible bool)
                                (insurance-policy (string-ascii 50))
                                (insurance-expiry uint))
  (let (
    (new-vehicle-id (+ (var-get vehicle-counter) u1))
    (current-block stacks-block-height)
  )
    ;; Validate inputs
    (asserts! (> (len make-model) u0) (err err-invalid-input))
    (asserts! (> year u1990) (err err-invalid-input))
    (asserts! (> insurance-expiry current-block) (err err-invalid-input))
    ;; Register vehicle
    (map-set vehicles { vehicle-id: new-vehicle-id }
      {
        owner: tx-sender,
        vehicle-type: vehicle-type,
        make-model: make-model,
        year: year,
        license-plate: license-plate,
        vin-number: "",
        insurance-policy: insurance-policy,
        insurance-expiry: insurance-expiry,
        inspection-date: current-block,
        inspection-expiry: (+ current-block u17520), ;; ~1 year
        wheelchair-accessible: wheelchair-accessible,
        wheelchair-capacity: wheelchair-capacity,
        stretcher-compatible: stretcher-compatible,
        oxygen-equipment-compatible: false,
        gps-tracking-enabled: false,
        maintenance-schedule: "Every 3 months",
        last-maintenance: current-block,
        next-maintenance: (+ current-block u4380), ;; ~3 months
        current-mileage: u0,
        availability-status: "available",
        current-location: "Home base",
        assigned-driver: none
      }
    )
    ;; Update counters
    (var-set vehicle-counter new-vehicle-id)
    (var-set total-vehicles (+ (var-get total-vehicles) u1))
    (ok new-vehicle-id)
  )
)

;; Schedule medical appointment transport
(define-public (schedule-appointment (patient-id uint)
                                    (healthcare-facility (string-ascii 150))
                                    (facility-address (string-ascii 200))
                                    (appointment-date uint)
                                    (appointment-time (string-ascii 10))
                                    (appointment-type (string-ascii 50))
                                    (pickup-address (string-ascii 200))
                                    (return-trip-needed bool)
                                    (priority-level uint))
  (let (
    (patient (unwrap! (map-get? patients { patient-id: patient-id }) (err err-not-found)))
    (new-appointment-id (+ (var-get appointment-counter) u1))
    (current-block stacks-block-height)
  )
    ;; Validate appointment scheduling
    (asserts! (is-eq tx-sender (get user patient)) (err err-unauthorized))
    (asserts! (get active patient) (err err-not-found))
    (asserts! (> appointment-date current-block) (err err-invalid-input))
    (asserts! (>= priority-level u1) (err err-invalid-input))
    (asserts! (<= priority-level u5) (err err-invalid-input))
    ;; Create appointment
    (map-set appointments { appointment-id: new-appointment-id }
      {
        patient-id: patient-id,
        healthcare-facility: healthcare-facility,
        facility-address: facility-address,
        appointment-date: appointment-date,
        appointment-time: appointment-time,
        appointment-type: appointment-type,
        estimated-duration: u60, ;; Default 60 minutes
        pickup-address: pickup-address,
        special-instructions: "",
        mobility-requirements: (get mobility-needs patient),
        medical-equipment-needed: "",
        preferred-arrival-time: appointment-time,
        return-trip-needed: return-trip-needed,
        return-pickup-time: "",
        caregiver-accompanying: false,
        priority-level: priority-level,
        confirmed: false,
        assigned-driver: none,
        assigned-vehicle: none,
        created-date: current-block,
        last-updated: current-block
      }
    )
    ;; Update counter
    (var-set appointment-counter new-appointment-id)
    (ok new-appointment-id)
  )
)

;; Dispatch driver for appointment
(define-public (dispatch-driver (appointment-id uint)
                               (driver-id uint)
                               (vehicle-id uint))
  (let (
    (appointment (unwrap! (map-get? appointments { appointment-id: appointment-id }) (err err-not-found)))
    (driver (unwrap! (map-get? drivers { driver-id: driver-id }) (err err-not-found)))
    (vehicle (unwrap! (map-get? vehicles { vehicle-id: vehicle-id }) (err err-not-found)))
    (new-trip-id (+ (var-get trip-counter) u1))
    (current-block stacks-block-height)
  )
    ;; Validate dispatch authority and availability
    (asserts! (or (is-eq tx-sender contract-owner) (is-driver-authorized tx-sender driver-id)) (err err-unauthorized))
    (asserts! (get active driver) (err err-driver-unavailable))
    (asserts! (is-eq (get availability-status vehicle) "available") (err err-vehicle-unavailable))
    (asserts! (is-eq (get background-check-status driver) "approved") (err err-background-check-failed))
    ;; Create trip record
    (map-set trips { trip-id: new-trip-id }
      {
        appointment-id: appointment-id,
        driver-id: driver-id,
        vehicle-id: vehicle-id,
        patient-id: (get patient-id appointment),
        trip-type: "pickup",
        pickup-address: (get pickup-address appointment),
        destination-address: (get facility-address appointment),
        scheduled-pickup-time: (get appointment-date appointment),
        actual-pickup-time: u0,
        scheduled-arrival-time: (get appointment-date appointment),
        actual-arrival-time: u0,
        trip-status: "scheduled",
        distance-miles: u0,
        estimated-duration: u30, ;; 30 minutes default
        actual-duration: u0,
        route-taken: "",
        passenger-count: u1,
        special-equipment-used: "",
        trip-notes: "",
        patient-rating: u0,
        driver-rating: u0,
        incident-reported: false,
        incident-details: "",
        trip-cost: u0,
        reimbursement-amount: u0,
        completed-date: u0
      }
    )
    ;; Update appointment with assignment
    (map-set appointments { appointment-id: appointment-id }
      (merge appointment {
        assigned-driver: (some driver-id),
        assigned-vehicle: (some vehicle-id),
        confirmed: true,
        last-updated: current-block
      })
    )
    ;; Update vehicle status
    (map-set vehicles { vehicle-id: vehicle-id }
      (merge vehicle {
        availability-status: "in-use",
        assigned-driver: (some driver-id)
      })
    )
    ;; Update counters
    (var-set trip-counter new-trip-id)
    (ok new-trip-id)
  )
)

;; Complete trip and record outcome
(define-public (complete-trip (trip-id uint)
                             (actual-pickup-time uint)
                             (actual-arrival-time uint)
                             (distance-miles uint)
                             (trip-notes (string-ascii 400))
                             (patient-rating uint))
  (let (
    (trip (unwrap! (map-get? trips { trip-id: trip-id }) (err err-not-found)))
    (driver (unwrap! (map-get? drivers { driver-id: (get driver-id trip) }) (err err-not-found)))
    (vehicle (unwrap! (map-get? vehicles { vehicle-id: (get vehicle-id trip) }) (err err-not-found)))
    (current-block stacks-block-height)
  )
    ;; Validate completion authority
    (asserts! (is-driver-authorized tx-sender (get driver-id trip)) (err err-unauthorized))
    (asserts! (is-eq (get trip-status trip) "in-progress") (err err-invalid-input))
    (asserts! (>= patient-rating u1) (err err-invalid-input))
    (asserts! (<= patient-rating u5) (err err-invalid-input))
    ;; Update trip record
    (map-set trips { trip-id: trip-id }
      (merge trip {
        actual-pickup-time: actual-pickup-time,
        actual-arrival-time: actual-arrival-time,
        trip-status: "completed",
        distance-miles: distance-miles,
        actual-duration: (calculate-duration actual-pickup-time actual-arrival-time),
        trip-notes: trip-notes,
        patient-rating: patient-rating,
        completed-date: current-block
      })
    )
    ;; Update vehicle availability
    (map-set vehicles { vehicle-id: (get vehicle-id trip) }
      (merge vehicle {
        availability-status: "available",
        assigned-driver: none,
        current-mileage: (+ (get current-mileage vehicle) distance-miles)
      })
    )
    ;; Update driver statistics
    (map-set drivers { driver-id: (get driver-id trip) }
      (merge driver {
        total-trips-completed: (+ (get total-trips-completed driver) u1),
        average-rating: (calculate-new-rating (get average-rating driver) (get rating-count driver) patient-rating),
        rating-count: (+ (get rating-count driver) u1),
        last-active: current-block
      })
    )
    ;; Update global statistics
    (var-set completed-trips (+ (var-get completed-trips) u1))
    (ok true)
  )
)

;; Update driver background check status
(define-public (update-background-check (driver-id uint) (status (string-ascii 20)))
  (let (
    (driver (unwrap! (map-get? drivers { driver-id: driver-id }) (err err-not-found)))
    (current-block stacks-block-height)
  )
    ;; Only contract owner can update background check
    (asserts! (is-eq tx-sender contract-owner) (err err-owner-only))
    ;; Update driver status
    (map-set drivers { driver-id: driver-id }
      (merge driver {
        background-check-date: current-block,
        background-check-status: status,
        active: (is-eq status "approved")
      })
    )
    (ok true)
  )
)

;; Emergency dispatch for urgent medical transport
(define-public (emergency-dispatch (patient-id uint)
                                  (emergency-type (string-ascii 50))
                                  (urgency-level uint)
                                  (pickup-location (string-ascii 200))
                                  (destination-facility (string-ascii 150))
                                  (medical-condition (string-ascii 200)))
  (let (
    (patient (unwrap! (map-get? patients { patient-id: patient-id }) (err err-not-found)))
    (new-emergency-id (+ (var-get appointment-counter) u1))
    (current-block stacks-block-height)
  )
    ;; Validate emergency dispatch
    (asserts! (get active patient) (err err-not-found))
    (asserts! (>= urgency-level u1) (err err-invalid-input))
    (asserts! (<= urgency-level u5) (err err-invalid-input))
    ;; Create emergency dispatch
    (map-set emergency-dispatches { emergency-id: new-emergency-id }
      {
        patient-id: patient-id,
        emergency-type: emergency-type,
        urgency-level: urgency-level,
        pickup-location: pickup-location,
        destination-facility: destination-facility,
        medical-condition: medical-condition,
        special-requirements: (get accessibility-requirements patient),
        requested-time: current-block,
        dispatcher: tx-sender,
        available-drivers: (list),
        assigned-driver: none,
        assigned-vehicle: none,
        response-time: u0,
        dispatch-status: "pending",
        family-notified: false,
        healthcare-facility-notified: false,
        created-timestamp: current-block
      }
    )
    (ok new-emergency-id)
  )
)

;; Read-only Functions

;; Get driver information
(define-read-only (get-driver (driver-id uint))
  (map-get? drivers { driver-id: driver-id })
)

;; Get patient information
(define-read-only (get-patient (patient-id uint))
  (map-get? patients { patient-id: patient-id })
)

;; Get vehicle information
(define-read-only (get-vehicle (vehicle-id uint))
  (map-get? vehicles { vehicle-id: vehicle-id })
)

;; Get appointment details
(define-read-only (get-appointment (appointment-id uint))
  (map-get? appointments { appointment-id: appointment-id })
)

;; Get trip information
(define-read-only (get-trip (trip-id uint))
  (map-get? trips { trip-id: trip-id })
)

;; Get emergency dispatch information
(define-read-only (get-emergency-dispatch (emergency-id uint))
  (map-get? emergency-dispatches { emergency-id: emergency-id })
)

;; Get system statistics
(define-read-only (get-system-stats)
  {
    total-drivers: (var-get total-drivers),
    total-patients: (var-get total-patients),
    total-vehicles: (var-get total-vehicles),
    completed-trips: (var-get completed-trips),
    active-appointments: (var-get appointment-counter),
    emergency-contact: (var-get emergency-contact)
  }
)

;; Get available drivers for emergency
(define-read-only (get-available-emergency-drivers)
  ;; Simplified implementation - would filter active, certified drivers
  {
    message: "Emergency drivers available - contact dispatch",
    total-active-drivers: (var-get total-drivers)
  }
)

;; Private Functions

;; Check if user is authorized driver
(define-private (is-driver-authorized (user principal) (driver-id uint))
  (match (map-get? drivers { driver-id: driver-id })
    driver (is-eq user (get user driver))
    false
  )
)

;; Calculate trip duration
(define-private (calculate-duration (start-time uint) (end-time uint))
  (if (> end-time start-time)
    (- end-time start-time)
    u0
  )
)

;; Calculate new average rating
(define-private (calculate-new-rating (current-rating uint) (rating-count uint) (new-rating uint))
  (let (
    (total-points (+ (* current-rating rating-count) new-rating))
    (new-count (+ rating-count u1))
  )
    (if (> new-count u0)
      (/ total-points new-count)
      new-rating
    )
  )
)

;; Check vehicle wheelchair compatibility
(define-private (is-wheelchair-compatible (vehicle-id uint) (patient-needs (string-ascii 100)))
  (match (map-get? vehicles { vehicle-id: vehicle-id })
    vehicle (if (is-eq patient-needs "wheelchair")
              (get wheelchair-accessible vehicle)
              true)
    false
  )
)
