;; Healthcare Access Equity Contract
;; Transportation vouchers and telemedicine infrastructure for rural areas
;; Bridging healthcare access gaps through technology and community support

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only u600)
(define-constant err-unauthorized u601)
(define-constant err-not-found u602)
(define-constant err-already-exists u603)
(define-constant err-invalid-input u604)
(define-constant err-insufficient-funds u605)
(define-constant err-voucher-expired u606)
(define-constant err-provider-inactive u607)
(define-constant err-appointment-unavailable u608)
(define-constant err-equipment-unavailable u609)
(define-constant err-network-capacity-exceeded u610)

;; Data Variables
(define-data-var patient-counter uint u0)
(define-data-var provider-counter uint u0)
(define-data-var voucher-counter uint u0)
(define-data-var telemedicine-session-counter uint u0)
(define-data-var facility-counter uint u0)
(define-data-var total-patients uint u0)
(define-data-var total-providers uint u0)
(define-data-var total-vouchers-issued uint u0)
(define-data-var total-vouchers-redeemed uint u0)
(define-data-var total-telemedicine-sessions uint u0)
(define-data-var voucher-fund-balance uint u1000000) ;; Starting fund in micro-STX
(define-data-var emergency-fund-balance uint u500000) ;; Emergency transportation fund

;; Data Maps
;; Patient registration for healthcare access programs
(define-map patients
  { patient-id: uint }
  {
    user: principal,
    name: (string-ascii 100),
    phone: (string-ascii 20),
    address: (string-ascii 200),
    rural-area-classification: (string-ascii 50), ;; remote, rural, frontier
    distance-to-nearest-hospital: uint, ;; miles
    transportation-barriers: (string-ascii 200),
    income-level: (string-ascii 30), ;; low, very-low, extremely-low
    insurance-status: (string-ascii 50),
    chronic-conditions: (string-ascii 200),
    mobility-limitations: (string-ascii 150),
    preferred-language: (string-ascii 30),
    internet-access-level: (string-ascii 50), ;; none, dial-up, broadband, high-speed
    technology-comfort-level: uint, ;; 1-5 scale
    emergency-contact: (string-ascii 100),
    case-manager: (optional principal),
    vouchers-received: uint,
    vouchers-used: uint,
    telemedicine-sessions: uint,
    last-healthcare-visit: uint,
    registration-date: uint,
    active: bool
  }
)

;; Healthcare provider network for rural and underserved areas
(define-map healthcare-providers
  { provider-id: uint }
  {
    user: principal,
    organization-name: (string-ascii 150),
    provider-type: (string-ascii 50), ;; hospital, clinic, specialist, mobile-unit
    services-offered: (string-ascii 300),
    service-area: (string-ascii 200), ;; counties or regions served
    address: (string-ascii 200),
    phone: (string-ascii 20),
    accepts-vouchers: bool,
    telemedicine-capable: bool,
    mobile-services-available: bool,
    wheelchair-accessible: bool,
    languages-supported: (string-ascii 100),
    insurance-accepted: (string-ascii 200),
    appointment-scheduling: (string-ascii 100),
    hours-of-operation: (string-ascii 150),
    emergency-services: bool,
    transportation-assistance: bool,
    voucher-redemption-count: uint,
    telemedicine-sessions-provided: uint,
    patient-satisfaction-rating: uint, ;; 1-5 scale
    rating-count: uint,
    last-updated: uint,
    active: bool
  }
)

;; Transportation voucher system
(define-map transportation-vouchers
  { voucher-id: uint }
  {
    patient-id: uint,
    voucher-type: (string-ascii 50), ;; gas, taxi, public-transport, emergency
    voucher-amount: uint, ;; in micro-STX
    purpose: (string-ascii 100), ;; appointment type or medical need
    healthcare-provider: uint, ;; provider-id
    appointment-date: uint,
    pickup-address: (string-ascii 200),
    destination-address: (string-ascii 200),
    estimated-distance: uint, ;; miles
    voucher-restrictions: (string-ascii 200),
    issue-date: uint,
    expiration-date: uint,
    redemption-date: uint,
    redeemed-by: (optional principal),
    redemption-amount: uint,
    status: (string-ascii 20), ;; issued, redeemed, expired, cancelled
    approval-required: bool,
    approved-by: (optional principal),
    approval-date: uint,
    notes: (string-ascii 300)
  }
)

;; Telemedicine infrastructure and session management
(define-map telemedicine-sessions
  { session-id: uint }
  {
    patient-id: uint,
    provider-id: uint,
    session-type: (string-ascii 50), ;; consultation, follow-up, mental-health
    scheduled-date: uint,
    scheduled-time: (string-ascii 10), ;; HH:MM format
    duration-minutes: uint,
    technology-platform: (string-ascii 50), ;; zoom, teams, proprietary
    internet-quality-required: (string-ascii 30), ;; basic, standard, high-definition
    equipment-needed: (string-ascii 150), ;; camera, microphone, blood-pressure-cuff
    interpreter-needed: bool,
    interpreter-language: (string-ascii 30),
    session-status: (string-ascii 20), ;; scheduled, in-progress, completed, cancelled
    connection-quality: uint, ;; 1-5 scale
    technical-issues: bool,
    technical-support-provided: bool,
    patient-satisfaction: uint, ;; 1-5 scale
    provider-notes: (string-ascii 400),
    follow-up-required: bool,
    prescription-sent: bool,
    referral-made: bool,
    session-recording-consent: bool,
    created-date: uint,
    completed-date: uint
  }
)

;; Rural healthcare facility network
(define-map healthcare-facilities
  { facility-id: uint }
  {
    facility-name: (string-ascii 150),
    facility-type: (string-ascii 50), ;; clinic, hospital, mobile-unit, telehealth-hub
    address: (string-ascii 200),
    coordinates: (string-ascii 50), ;; latitude, longitude
    service-population: uint, ;; estimated population served
    distance-to-major-hospital: uint, ;; miles
    services-available: (string-ascii 300),
    specialties-offered: (string-ascii 200),
    equipment-available: (string-ascii 200),
    telemedicine-capabilities: bool,
    high-speed-internet: bool,
    backup-power: bool,
    helicopter-landing-pad: bool,
    wheelchair-accessible: bool,
    public-transportation-access: bool,
    parking-available: bool,
    hours-of-operation: (string-ascii 100),
    emergency-services-24_7: bool,
    staff-count: uint,
    bed-capacity: uint,
    ambulance-services: bool,
    patient-transport-coordination: bool,
    community-outreach-programs: bool,
    last-inspection-date: uint,
    accreditation-status: (string-ascii 50),
    funding-sources: (string-ascii 200)
  }
)

;; Internet connectivity and technology access tracking
(define-map connectivity-infrastructure
  { area-id: uint }
  {
    geographic-area: (string-ascii 100), ;; county, zip code, or region
    population-density: uint, ;; people per square mile
    internet-service-providers: (string-ascii 200),
    broadband-availability: uint, ;; percentage of area covered
    average-internet-speed: uint, ;; Mbps
    mobile-coverage-quality: (string-ascii 20), ;; poor, fair, good, excellent
    public-wifi-locations: uint,
    digital-literacy-programs: uint,
    technology-assistance-centers: uint,
    device-lending-programs: bool,
    internet-subsidy-programs: bool,
    telehealth-hubs: uint,
    library-telehealth-access: bool,
    school-after-hours-access: bool,
    community-center-access: bool,
    funding-for-improvements: uint,
    planned-infrastructure-upgrades: (string-ascii 300),
    last-assessment-date: uint
  }
)

;; Community health worker and navigator coordination
(define-map community-health-workers
  { worker-id: uint }
  {
    user: principal,
    name: (string-ascii 100),
    certification-level: (string-ascii 50),
    service-areas: (string-ascii 200),
    languages-spoken: (string-ascii 100),
    specialization: (string-ascii 150), ;; diabetes, mental-health, maternal
    training-completed: (string-ascii 200),
    patients-served: uint,
    home-visits-conducted: uint,
    telehealth-sessions-facilitated: uint,
    referrals-made: uint,
    transportation-coordinated: uint,
    health-education-sessions: uint,
    community-outreach-events: uint,
    average-patient-outcome-rating: uint, ;; 1-5 scale
    supervisor: (optional principal),
    employment-status: (string-ascii 30), ;; volunteer, part-time, full-time
    compensation-rate: uint,
    last-training-date: uint,
    next-certification-date: uint,
    active: bool
  }
)

;; Emergency medical transport coordination
(define-map emergency-transports
  { transport-id: uint }
  {
    patient-id: uint,
    emergency-type: (string-ascii 50), ;; cardiac, stroke, trauma, dialysis
    urgency-level: uint, ;; 1-5, with 5 being life-threatening
    pickup-location: (string-ascii 200),
    destination-facility: uint, ;; facility-id
    transport-method: (string-ascii 30), ;; ambulance, helicopter, fixed-wing
    medical-team-required: bool,
    special-equipment-needed: (string-ascii 150),
    estimated-distance: uint, ;; miles
    estimated-time: uint, ;; minutes
    weather-conditions: (string-ascii 50),
    road-conditions: (string-ascii 50),
    coordination-center: principal,
    dispatch-time: uint,
    pickup-time: uint,
    arrival-time: uint,
    transport-cost: uint,
    insurance-coverage: uint,
    voucher-coverage: uint,
    patient-copay: uint,
    transport-outcome: (string-ascii 50), ;; successful, diverted, cancelled
    complications: (string-ascii 300),
    follow-up-required: bool,
    family-notification: bool
  }
)

;; Public Functions

;; Register patient for healthcare access programs
(define-public (register-patient (name (string-ascii 100))
                                (phone (string-ascii 20))
                                (address (string-ascii 200))
                                (rural-classification (string-ascii 50))
                                (distance-to-hospital uint)
                                (transportation-barriers (string-ascii 200))
                                (income-level (string-ascii 30))
                                (insurance-status (string-ascii 50))
                                (internet-access (string-ascii 50))
                                (tech-comfort uint))
  (let (
    (new-patient-id (+ (var-get patient-counter) u1))
    (current-block stacks-block-height)
  )
    ;; Validate inputs
    (asserts! (> (len name) u0) (err err-invalid-input))
    (asserts! (> distance-to-hospital u0) (err err-invalid-input))
    (asserts! (>= tech-comfort u1) (err err-invalid-input))
    (asserts! (<= tech-comfort u5) (err err-invalid-input))
    ;; Register patient
    (map-set patients { patient-id: new-patient-id }
      {
        user: tx-sender,
        name: name,
        phone: phone,
        address: address,
        rural-area-classification: rural-classification,
        distance-to-nearest-hospital: distance-to-hospital,
        transportation-barriers: transportation-barriers,
        income-level: income-level,
        insurance-status: insurance-status,
        chronic-conditions: "",
        mobility-limitations: "",
        preferred-language: "English",
        internet-access-level: internet-access,
        technology-comfort-level: tech-comfort,
        emergency-contact: "",
        case-manager: none,
        vouchers-received: u0,
        vouchers-used: u0,
        telemedicine-sessions: u0,
        last-healthcare-visit: u0,
        registration-date: current-block,
        active: true
      }
    )
    ;; Update counters
    (var-set patient-counter new-patient-id)
    (var-set total-patients (+ (var-get total-patients) u1))
    (ok new-patient-id)
  )
)

;; Register healthcare provider in the network
(define-public (register-healthcare-provider (organization-name (string-ascii 150))
                                            (provider-type (string-ascii 50))
                                            (services-offered (string-ascii 300))
                                            (service-area (string-ascii 200))
                                            (address (string-ascii 200))
                                            (phone (string-ascii 20))
                                            (accepts-vouchers bool)
                                            (telemedicine-capable bool)
                                            (wheelchair-accessible bool))
  (let (
    (new-provider-id (+ (var-get provider-counter) u1))
    (current-block stacks-block-height)
  )
    ;; Validate inputs
    (asserts! (> (len organization-name) u0) (err err-invalid-input))
    (asserts! (> (len services-offered) u10) (err err-invalid-input))
    ;; Register provider
    (map-set healthcare-providers { provider-id: new-provider-id }
      {
        user: tx-sender,
        organization-name: organization-name,
        provider-type: provider-type,
        services-offered: services-offered,
        service-area: service-area,
        address: address,
        phone: phone,
        accepts-vouchers: accepts-vouchers,
        telemedicine-capable: telemedicine-capable,
        mobile-services-available: false,
        wheelchair-accessible: wheelchair-accessible,
        languages-supported: "English",
        insurance-accepted: "",
        appointment-scheduling: "Call to schedule",
        hours-of-operation: "Monday-Friday 8AM-5PM",
        emergency-services: false,
        transportation-assistance: false,
        voucher-redemption-count: u0,
        telemedicine-sessions-provided: u0,
        patient-satisfaction-rating: u5, ;; Default good rating
        rating-count: u0,
        last-updated: current-block,
        active: true
      }
    )
    ;; Update counters
    (var-set provider-counter new-provider-id)
    (var-set total-providers (+ (var-get total-providers) u1))
    (ok new-provider-id)
  )
)

;; Issue transportation voucher
(define-public (issue-voucher (patient-id uint)
                             (voucher-type (string-ascii 50))
                             (voucher-amount uint)
                             (purpose (string-ascii 100))
                             (healthcare-provider uint)
                             (appointment-date uint)
                             (pickup-address (string-ascii 200))
                             (destination-address (string-ascii 200)))
  (let (
    (patient (unwrap! (map-get? patients { patient-id: patient-id }) (err err-not-found)))
    (provider (unwrap! (map-get? healthcare-providers { provider-id: healthcare-provider }) (err err-not-found)))
    (new-voucher-id (+ (var-get voucher-counter) u1))
    (current-block stacks-block-height)
    (expiry-date (+ current-block u4320)) ;; 30 days from issue
  )
    ;; Validate voucher issuance
    (asserts! (get active patient) (err err-not-found))
    (asserts! (get active provider) (err err-provider-inactive))
    (asserts! (get accepts-vouchers provider) (err err-provider-inactive))
    (asserts! (>= (var-get voucher-fund-balance) voucher-amount) (err err-insufficient-funds))
    (asserts! (> appointment-date current-block) (err err-invalid-input))
    ;; Create voucher
    (map-set transportation-vouchers { voucher-id: new-voucher-id }
      {
        patient-id: patient-id,
        voucher-type: voucher-type,
        voucher-amount: voucher-amount,
        purpose: purpose,
        healthcare-provider: healthcare-provider,
        appointment-date: appointment-date,
        pickup-address: pickup-address,
        destination-address: destination-address,
        estimated-distance: u0,
        voucher-restrictions: "Valid for medical appointments only",
        issue-date: current-block,
        expiration-date: expiry-date,
        redemption-date: u0,
        redeemed-by: none,
        redemption-amount: u0,
        status: "issued",
        approval-required: (> voucher-amount u50000), ;; Amounts over $50 need approval
        approved-by: none,
        approval-date: u0,
        notes: ""
      }
    )
    ;; Update patient voucher count
    (map-set patients { patient-id: patient-id }
      (merge patient {
        vouchers-received: (+ (get vouchers-received patient) u1)
      })
    )
    ;; Update counters and fund balance
    (var-set voucher-counter new-voucher-id)
    (var-set total-vouchers-issued (+ (var-get total-vouchers-issued) u1))
    (var-set voucher-fund-balance (- (var-get voucher-fund-balance) voucher-amount))
    (ok new-voucher-id)
  )
)

;; Redeem transportation voucher
(define-public (redeem-voucher (voucher-id uint) (actual-amount uint))
  (let (
    (voucher (unwrap! (map-get? transportation-vouchers { voucher-id: voucher-id }) (err err-not-found)))
    (patient (unwrap! (map-get? patients { patient-id: (get patient-id voucher) }) (err err-not-found)))
    (current-block stacks-block-height)
  )
    ;; Validate redemption
    (asserts! (is-eq (get status voucher) "issued") (err err-invalid-input))
    (asserts! (< current-block (get expiration-date voucher)) (err err-voucher-expired))
    (asserts! (<= actual-amount (get voucher-amount voucher)) (err err-invalid-input))
    ;; Process redemption
    (map-set transportation-vouchers { voucher-id: voucher-id }
      (merge voucher {
        redemption-date: current-block,
        redeemed-by: (some tx-sender),
        redemption-amount: actual-amount,
        status: "redeemed"
      })
    )
    ;; Update patient statistics
    (map-set patients { patient-id: (get patient-id voucher) }
      (merge patient {
        vouchers-used: (+ (get vouchers-used patient) u1)
      })
    )
    ;; Update provider statistics if applicable
    (match (map-get? healthcare-providers { provider-id: (get healthcare-provider voucher) })
      provider (map-set healthcare-providers { provider-id: (get healthcare-provider voucher) }
                 (merge provider {
                   voucher-redemption-count: (+ (get voucher-redemption-count provider) u1)
                 })
               )
      false
    )
    ;; Update global statistics
    (var-set total-vouchers-redeemed (+ (var-get total-vouchers-redeemed) u1))
    (ok actual-amount)
  )
)

;; Schedule telemedicine session
(define-public (schedule-telemedicine (patient-id uint)
                                     (provider-id uint)
                                     (session-type (string-ascii 50))
                                     (scheduled-date uint)
                                     (scheduled-time (string-ascii 10))
                                     (duration-minutes uint)
                                     (platform (string-ascii 50))
                                     (interpreter-needed bool))
  (let (
    (patient (unwrap! (map-get? patients { patient-id: patient-id }) (err err-not-found)))
    (provider (unwrap! (map-get? healthcare-providers { provider-id: provider-id }) (err err-not-found)))
    (new-session-id (+ (var-get telemedicine-session-counter) u1))
    (current-block stacks-block-height)
  )
    ;; Validate session scheduling
    (asserts! (get active patient) (err err-not-found))
    (asserts! (get active provider) (err err-provider-inactive))
    (asserts! (get telemedicine-capable provider) (err err-provider-inactive))
    (asserts! (> scheduled-date current-block) (err err-invalid-input))
    (asserts! (> duration-minutes u0) (err err-invalid-input))
    ;; Create telemedicine session
    (map-set telemedicine-sessions { session-id: new-session-id }
      {
        patient-id: patient-id,
        provider-id: provider-id,
        session-type: session-type,
        scheduled-date: scheduled-date,
        scheduled-time: scheduled-time,
        duration-minutes: duration-minutes,
        technology-platform: platform,
        internet-quality-required: "standard",
        equipment-needed: "camera, microphone",
        interpreter-needed: interpreter-needed,
        interpreter-language: (if interpreter-needed (get preferred-language patient) ""),
        session-status: "scheduled",
        connection-quality: u0,
        technical-issues: false,
        technical-support-provided: false,
        patient-satisfaction: u0,
        provider-notes: "",
        follow-up-required: false,
        prescription-sent: false,
        referral-made: false,
        session-recording-consent: false,
        created-date: current-block,
        completed-date: u0
      }
    )
    ;; Update patient telemedicine session count
    (map-set patients { patient-id: patient-id }
      (merge patient {
        telemedicine-sessions: (+ (get telemedicine-sessions patient) u1)
      })
    )
    ;; Update counters
    (var-set telemedicine-session-counter new-session-id)
    (var-set total-telemedicine-sessions (+ (var-get total-telemedicine-sessions) u1))
    (ok new-session-id)
  )
)

;; Complete telemedicine session
(define-public (complete-telemedicine-session (session-id uint)
                                             (connection-quality uint)
                                             (technical-issues bool)
                                             (patient-satisfaction uint)
                                             (provider-notes (string-ascii 400))
                                             (follow-up-required bool))
  (let (
    (session (unwrap! (map-get? telemedicine-sessions { session-id: session-id }) (err err-not-found)))
    (provider (unwrap! (map-get? healthcare-providers { provider-id: (get provider-id session) }) (err err-not-found)))
    (current-block stacks-block-height)
  )
    ;; Validate completion authority
    (asserts! (is-eq tx-sender (get user provider)) (err err-unauthorized))
    (asserts! (is-eq (get session-status session) "scheduled") (err err-invalid-input))
    (asserts! (>= connection-quality u1) (err err-invalid-input))
    (asserts! (<= connection-quality u5) (err err-invalid-input))
    (asserts! (>= patient-satisfaction u1) (err err-invalid-input))
    (asserts! (<= patient-satisfaction u5) (err err-invalid-input))
    ;; Update session record
    (map-set telemedicine-sessions { session-id: session-id }
      (merge session {
        session-status: "completed",
        connection-quality: connection-quality,
        technical-issues: technical-issues,
        technical-support-provided: technical-issues, ;; Assume support provided if issues occurred
        patient-satisfaction: patient-satisfaction,
        provider-notes: provider-notes,
        follow-up-required: follow-up-required,
        completed-date: current-block
      })
    )
    ;; Update provider statistics
    (map-set healthcare-providers { provider-id: (get provider-id session) }
      (merge provider {
        telemedicine-sessions-provided: (+ (get telemedicine-sessions-provided provider) u1),
        patient-satisfaction-rating: (calculate-new-rating (get patient-satisfaction-rating provider) (get rating-count provider) patient-satisfaction),
        rating-count: (+ (get rating-count provider) u1),
        last-updated: current-block
      })
    )
    (ok true)
  )
)

;; Coordinate emergency medical transport
(define-public (coordinate-emergency-transport (patient-id uint)
                                              (emergency-type (string-ascii 50))
                                              (urgency-level uint)
                                              (pickup-location (string-ascii 200))
                                              (destination-facility uint)
                                              (transport-method (string-ascii 30)))
  (let (
    (patient (unwrap! (map-get? patients { patient-id: patient-id }) (err err-not-found)))
    (facility (unwrap! (map-get? healthcare-facilities { facility-id: destination-facility }) (err err-not-found)))
    (new-transport-id (+ (var-get telemedicine-session-counter) u1))
    (current-block stacks-block-height)
  )
    ;; Validate emergency transport
    (asserts! (get active patient) (err err-not-found))
    (asserts! (>= urgency-level u1) (err err-invalid-input))
    (asserts! (<= urgency-level u5) (err err-invalid-input))
    ;; Create emergency transport record
    (map-set emergency-transports { transport-id: new-transport-id }
      {
        patient-id: patient-id,
        emergency-type: emergency-type,
        urgency-level: urgency-level,
        pickup-location: pickup-location,
        destination-facility: destination-facility,
        transport-method: transport-method,
        medical-team-required: (>= urgency-level u4),
        special-equipment-needed: "",
        estimated-distance: (get distance-to-nearest-hospital patient),
        estimated-time: (* (get distance-to-nearest-hospital patient) u2), ;; 2 minutes per mile estimate
        weather-conditions: "clear",
        road-conditions: "good",
        coordination-center: tx-sender,
        dispatch-time: current-block,
        pickup-time: u0,
        arrival-time: u0,
        transport-cost: u0,
        insurance-coverage: u0,
        voucher-coverage: u0,
        patient-copay: u0,
        transport-outcome: "dispatched",
        complications: "",
        follow-up-required: false,
        family-notification: false
      }
    )
    (ok new-transport-id)
  )
)

;; Register healthcare facility
(define-public (register-facility (facility-name (string-ascii 150))
                                 (facility-type (string-ascii 50))
                                 (address (string-ascii 200))
                                 (service-population uint)
                                 (distance-to-hospital uint)
                                 (telemedicine-capable bool)
                                 (emergency-services bool))
  (let (
    (new-facility-id (+ (var-get facility-counter) u1))
    (current-block stacks-block-height)
  )
    ;; Validate facility registration
    (asserts! (> (len facility-name) u0) (err err-invalid-input))
    (asserts! (> service-population u0) (err err-invalid-input))
    ;; Register facility
    (map-set healthcare-facilities { facility-id: new-facility-id }
      {
        facility-name: facility-name,
        facility-type: facility-type,
        address: address,
        coordinates: "",
        service-population: service-population,
        distance-to-major-hospital: distance-to-hospital,
        services-available: "",
        specialties-offered: "",
        equipment-available: "",
        telemedicine-capabilities: telemedicine-capable,
        high-speed-internet: false,
        backup-power: false,
        helicopter-landing-pad: false,
        wheelchair-accessible: true,
        public-transportation-access: false,
        parking-available: true,
        hours-of-operation: (if emergency-services "24/7" "8AM-5PM"),
        emergency-services-24_7: emergency-services,
        staff-count: u0,
        bed-capacity: u0,
        ambulance-services: false,
        patient-transport-coordination: false,
        community-outreach-programs: false,
        last-inspection-date: current-block,
        accreditation-status: "pending",
        funding-sources: ""
      }
    )
    ;; Update counter
    (var-set facility-counter new-facility-id)
    (ok new-facility-id)
  )
)

;; Read-only Functions

;; Get patient information
(define-read-only (get-patient (patient-id uint))
  (map-get? patients { patient-id: patient-id })
)

;; Get healthcare provider information
(define-read-only (get-healthcare-provider (provider-id uint))
  (map-get? healthcare-providers { provider-id: provider-id })
)

;; Get transportation voucher details
(define-read-only (get-voucher (voucher-id uint))
  (map-get? transportation-vouchers { voucher-id: voucher-id })
)

;; Get telemedicine session information
(define-read-only (get-telemedicine-session (session-id uint))
  (map-get? telemedicine-sessions { session-id: session-id })
)

;; Get healthcare facility information
(define-read-only (get-healthcare-facility (facility-id uint))
  (map-get? healthcare-facilities { facility-id: facility-id })
)

;; Get emergency transport information
(define-read-only (get-emergency-transport (transport-id uint))
  (map-get? emergency-transports { transport-id: transport-id })
)

;; Get system statistics
(define-read-only (get-system-statistics)
  {
    total-patients: (var-get total-patients),
    total-providers: (var-get total-providers),
    total-vouchers-issued: (var-get total-vouchers-issued),
    total-vouchers-redeemed: (var-get total-vouchers-redeemed),
    total-telemedicine-sessions: (var-get total-telemedicine-sessions),
    voucher-fund-balance: (var-get voucher-fund-balance),
    emergency-fund-balance: (var-get emergency-fund-balance)
  }
)

;; Get rural healthcare access metrics
(define-read-only (get-rural-access-metrics)
  ;; Simplified implementation - would calculate comprehensive metrics
  {
    message: "Rural healthcare access improving through technology and transportation",
    registered-rural-patients: (var-get total-patients),
    telemedicine-adoption-rate: (var-get total-telemedicine-sessions)
  }
)

;; Private Functions

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

;; Determine voucher eligibility based on patient profile
(define-private (is-eligible-for-voucher (patient-id uint) (voucher-amount uint))
  (match (map-get? patients { patient-id: patient-id })
    patient (let (
             (income-eligible (or (is-eq (get income-level patient) "low")
                                 (is-eq (get income-level patient) "very-low")
                                 (is-eq (get income-level patient) "extremely-low")))
             (distance-eligible (>= (get distance-to-nearest-hospital patient) u10))
             (barrier-eligible (> (len (get transportation-barriers patient)) u10))
           )
           (and income-eligible (or distance-eligible barrier-eligible))
         )
    false
  )
)

;; Check telemedicine technology requirements
(define-private (meets-telemedicine-requirements (patient-id uint))
  (match (map-get? patients { patient-id: patient-id })
    patient (let (
             (has-internet (not (is-eq (get internet-access-level patient) "none")))
             (tech-comfortable (>= (get technology-comfort-level patient) u3))
           )
           (and has-internet tech-comfortable)
         )
    false
  )
)

;; Calculate emergency transport priority
(define-private (calculate-transport-priority (urgency-level uint) (distance uint) (weather-factor uint))
  (let (
    (urgency-weight (* urgency-level u20))
    (distance-penalty (/ distance u10))
    (weather-adjustment weather-factor)
    (base-priority (+ urgency-weight weather-adjustment))
  )
    (if (> base-priority distance-penalty)
      (- base-priority distance-penalty)
      u1
    )
  )
)
